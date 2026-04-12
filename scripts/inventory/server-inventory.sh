#!/usr/bin/env bash
################################################################################
# Script: server-inventory.sh
# Description: Collect comprehensive inventory from Linux servers via SSH
# Author: Liquenson Ruben Alexis
# Version: 3.1.0
################################################################################
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly SCRIPT_DIR PROJECT_ROOT
readonly VERSION="3.1.0"

# Load libraries
if [[ -f "${PROJECT_ROOT}/lib/common.sh" ]]; then
    source "${PROJECT_ROOT}/lib/common.sh"
else
    echo "ERROR: common.sh not found" >&2
    exit 1
fi
[[ -f "${PROJECT_ROOT}/lib/logger.sh" ]] && source "${PROJECT_ROOT}/lib/logger.sh"

# =============================================================================
# DEFAULTS
# =============================================================================
ENV="default"
OUTPUT_FORMAT="csv"
LOCAL_MODE=false
SERVERS=()
readonly REPORTS_DIR="${PROJECT_ROOT}/reports"

# =============================================================================
# BANNER
# =============================================================================
print_banner() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║        LINUX FLEET MANAGER - SERVER INVENTORY                   ║
║                                                                  ║
║  Automated server discovery and inventory collection            ║
╚══════════════════════════════════════════════════════════════════╝
EOF
}

# =============================================================================
# USAGE
# =============================================================================
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Collect hardware and OS inventory from Linux servers.

Options:
  --env ENV         Target environment (default: default)
  --format FORMAT   Output format: csv or json (default: csv)
  --servers LIST    Comma-separated list of SSH hosts
  --local           Collect from local machine only (no SSH)
  --help            Show this help message and exit
  --version         Show version and exit

Examples:
  $(basename "$0") --format csv
  $(basename "$0") --format json --env production
  $(basename "$0") --servers web01,web02,db01 --format csv
  $(basename "$0") --local --format json
EOF
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================
parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --help|-h)
                usage
                exit 0
                ;;
            --version|-v)
                echo "server-inventory.sh version ${VERSION}"
                exit 0
                ;;
            --format)
                [[ -z "${2:-}" ]] && { log_error "--format requires a value (csv|json)"; exit 1; }
                OUTPUT_FORMAT="$2"
                shift
                ;;
            --env)
                [[ -z "${2:-}" ]] && { log_error "--env requires a value"; exit 1; }
                ENV="$2"
                shift
                ;;
            --servers)
                [[ -z "${2:-}" ]] && { log_error "--servers requires a value"; exit 1; }
                IFS="," read -ra SERVERS <<< "$2"
                shift
                ;;
            --local)
                LOCAL_MODE=true
                SERVERS=("local")
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done

    # Default to local mode if no servers specified
    if [[ ${#SERVERS[@]} -eq 0 ]]; then
        LOCAL_MODE=true
        SERVERS=("local")
    fi

    # Validate format
    if [[ "${OUTPUT_FORMAT}" != "csv" && "${OUTPUT_FORMAT}" != "json" ]]; then
        log_error "Unsupported format: ${OUTPUT_FORMAT}. Use csv or json."
        exit 1
    fi
}

# =============================================================================
# SSH EXECUTION
# =============================================================================
run_ssh() {
    local host="$1"
    local cmd="$2"
    ssh -o BatchMode=yes \
        -o ConnectTimeout=10 \
        -o StrictHostKeyChecking=no \
        "$host" "$cmd" 2>/dev/null
}

# =============================================================================
# LOCAL DATA COLLECTION (cross-platform)
# =============================================================================
collect_local_data() {
    local hostname ip os_name kernel cpu_count ram disk date_now
    local detected_os

    detected_os=$(uname)
    hostname=$(hostname)
    os_name=$(uname -s)
    kernel=$(uname -r)
    date_now=$(date +%Y-%m-%d)

    # CPU count — Linux / macOS / Windows Git Bash
    if command -v nproc >/dev/null 2>&1; then
        cpu_count=$(nproc)
    elif command -v sysctl >/dev/null 2>&1; then
        cpu_count=$(sysctl -n hw.ncpu 2>/dev/null || echo "N/A")
    else
        cpu_count="${NUMBER_OF_PROCESSORS:-N/A}"
    fi

    # IP address
    if command -v hostname >/dev/null 2>&1 && hostname -I >/dev/null 2>&1; then
        ip=$(hostname -I | awk '{print $1}')
    elif command -v ipconfig >/dev/null 2>&1; then
        ip=$(ipconfig 2>/dev/null | awk '/IPv4/ {print $NF}' | head -1 || echo "N/A")
    else
        ip="127.0.0.1"
    fi

    # RAM
    if [[ -f /proc/meminfo ]]; then
        ram=$(awk '/MemTotal/ {printf "%dMB", $2/1024}' /proc/meminfo)
    elif [[ "$detected_os" == "Darwin" ]]; then
        ram=$(sysctl -n hw.memsize 2>/dev/null | awk '{printf "%dMB", $1/1024/1024}' || echo "N/A")
    else
        ram="N/A"
    fi

    # Disk
    if df -h / >/dev/null 2>&1; then
        disk=$(df -h / | awk 'NR==2 {print $4}')
    else
        disk="N/A"
    fi

    echo "$hostname|$ip|$os_name|$kernel|$cpu_count|$ram|$disk|$date_now"
}

# =============================================================================
# REMOTE DATA COLLECTION (SSH)
# =============================================================================
collect_remote_data() {
    local host="$1"
    local hostname ip os_name kernel cpu_count ram disk date_now

    log_info "Collecting data from: $host"

    hostname=$(run_ssh "$host" "hostname" || echo "$host")
    ip=$(run_ssh "$host" "hostname -I | awk '{print \$1}'" || echo "N/A")
    os_name=$(run_ssh "$host" "uname -s" || echo "N/A")
    kernel=$(run_ssh "$host" "uname -r" || echo "N/A")
    cpu_count=$(run_ssh "$host" "nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo N/A")
    ram=$(run_ssh "$host" "awk '/MemTotal/ {printf \"%dMB\", \$2/1024}' /proc/meminfo 2>/dev/null || echo N/A")
    disk=$(run_ssh "$host" "df -h / | awk 'NR==2 {print \$4}'" || echo "N/A")
    date_now=$(date +%Y-%m-%d)

    echo "$hostname|$ip|$os_name|$kernel|$cpu_count|$ram|$disk|$date_now"
}

# =============================================================================
# COLLECT DATA (dispatcher)
# =============================================================================
collect_data() {
    local host="$1"
    if [[ "$LOCAL_MODE" == "true" || "$host" == "local" ]]; then
        collect_local_data
    else
        collect_remote_data "$host"
    fi
}

# =============================================================================
# OUTPUT WRITERS
# =============================================================================
write_csv() {
    local all_data="$1"
    local file="$2"
    {
        echo "Hostname,IP,OS,Kernel,CPU,RAM,Disk,Date"
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            echo "${line//|/,}"
        done <<< "$all_data"
    } > "$file"
    log_success "CSV saved: $file"
}

write_json() {
    local all_data="$1"
    local file="$2"
    local first=true

    echo "[" > "$file"
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        IFS="|" read -r hostname ip os_name kernel cpu ram disk date_now <<< "$line"
        [[ "$first" == "true" ]] && first=false || echo "," >> "$file"
        cat >> "$file" << EOF
  {
    "hostname": "${hostname}",
    "ip": "${ip}",
    "os": "${os_name}",
    "kernel": "${kernel}",
    "cpu": "${cpu}",
    "ram": "${ram}",
    "disk": "${disk}",
    "date": "${date_now}"
  }
EOF
    done <<< "$all_data"
    echo "]" >> "$file"
    log_success "JSON saved: $file"
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    parse_args "$@"
    print_banner

    log_info "Environment  : ${ENV}"
    log_info "Format       : ${OUTPUT_FORMAT}"
    log_info "Mode         : $([[ "$LOCAL_MODE" == "true" ]] && echo "local" || echo "ssh")"
    log_info "Servers      : ${SERVERS[*]}"

    ensure_dir "${REPORTS_DIR}"

    local timestamp output_file all_data=""
    timestamp=$(date +%Y%m%d_%H%M%S)
    output_file="${REPORTS_DIR}/server-inventory_${timestamp}.${OUTPUT_FORMAT}"

    log_info "Starting inventory collection..."

    for host in "${SERVERS[@]}"; do
        local data
        data=$(collect_data "$host")
        all_data+="${data}"$'\n'
    done

    case "${OUTPUT_FORMAT}" in
        csv)  write_csv  "$all_data" "$output_file" ;;
        json) write_json "$all_data" "$output_file" ;;
    esac

    log_success "Inventory completed — ${#SERVERS[@]} server(s) processed"
}

main "$@"