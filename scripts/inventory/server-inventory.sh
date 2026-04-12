#!/usr/bin/env bash
################################################################################
# Script: server-inventory.sh
# Description: Collect comprehensive inventory from Linux servers
# Author: Liquenson Ruben Alexis
# Version: 2.1.0
################################################################################
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly PROJECT_ROOT
readonly VERSION="2.1.0"

# Load libraries
if [[ -f "${PROJECT_ROOT}/lib/common.sh" ]]; then
    source "${PROJECT_ROOT}/lib/common.sh"
else
    echo "ERROR: Failed to load common.sh library" >&2
    exit 1
fi

if [[ -f "${PROJECT_ROOT}/lib/logger.sh" ]]; then
    source "${PROJECT_ROOT}/lib/logger.sh"
fi

# =============================================================================
# DEFAULTS
# =============================================================================
ENV="default"
OUTPUT_FORMAT="csv"
readonly REPORTS_DIR="${PROJECT_ROOT}/reports"

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
  --help            Show this help message and exit
  --version         Show version and exit

Examples:
  $(basename "$0") --format csv
  $(basename "$0") --format json --env production
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
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done
}

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
# DATA COLLECTION
# =============================================================================
collect_data() {
    local hostname ip os_name kernel cpu_count ram_gb disk_gb date_now

    hostname=$(hostname)
    ip=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")
    os_name=$(uname -s)
    kernel=$(uname -r)
    cpu_count=$(nproc 2>/dev/null || echo "${NUMBER_OF_PROCESSORS:-N/A}")
    ram_gb=$(awk '/MemTotal/ {printf "%.1f", $2/1024/1024}' /proc/meminfo 2>/dev/null || echo "N/A")
    disk_gb=$(df -BG / 2>/dev/null | awk 'NR==2 {print $2}' | tr -d 'G' || echo "N/A")
    date_now=$(date +%Y-%m-%d)

    echo "$hostname|$ip|$os_name|$kernel|$cpu_count|${ram_gb}GB|${disk_gb}GB|$date_now"
}

# =============================================================================
# OUTPUT WRITERS
# =============================================================================
write_csv() {
    local data="$1"
    local output_file="$2"
    {
        echo "Hostname,IP Address,OS Name,Kernel,CPU Count,RAM,Disk,Last Update"
        echo "${data//|/,}"
    } > "${output_file}"
    log_success "CSV report saved to: ${output_file}"
}

write_json() {
    local data="$1"
    local output_file="$2"
    IFS="|" read -r hostname ip os_name kernel cpu_count ram disk date_now <<< "$data"
    cat > "${output_file}" << EOF
[
  {
    "hostname": "${hostname}",
    "ip_address": "${ip}",
    "os_name": "${os_name}",
    "kernel": "${kernel}",
    "cpu_count": "${cpu_count}",
    "ram": "${ram}",
    "disk": "${disk}",
    "last_update": "${date_now}"
  }
]
EOF
    log_success "JSON report saved to: ${output_file}"
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    parse_args "$@"

    # Validate format
    if [[ "${OUTPUT_FORMAT}" != "csv" && "${OUTPUT_FORMAT}" != "json" ]]; then
        log_error "Unsupported format: ${OUTPUT_FORMAT}. Use csv or json."
        exit 1
    fi

    print_banner
    log_info "Environment : ${ENV}"
    log_info "Output format: ${OUTPUT_FORMAT}"

    ensure_dir "${REPORTS_DIR}"

    local timestamp output_file data
    timestamp="$(date +%Y%m%d_%H%M%S)"
    output_file="${REPORTS_DIR}/server-inventory_${timestamp}.${OUTPUT_FORMAT}"

    log_info "Starting server inventory collection..."

    data=$(collect_data)

    case "${OUTPUT_FORMAT}" in
        csv)  write_csv  "$data" "$output_file" ;;
        json) write_json "$data" "$output_file" ;;
    esac

    log_success "Inventory completed successfully"
}

main "$@"
