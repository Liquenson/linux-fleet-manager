#!/usr/bin/env bash
################################################################################
# Script: server-inventory.sh
# Description: Collect comprehensive inventory from Linux servers via SSH
# Author: Liquenson Ruben Alexis
# Version: 3.0.1
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly SCRIPT_DIR PROJECT_ROOT

readonly VERSION="3.0.1"

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
SERVERS=("server")   # Añade más servidores aquí

readonly REPORTS_DIR="${PROJECT_ROOT}/reports"

# =============================================================================
# BANNER (FIX CI ERROR)
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

Options:
  --env ENV         Target environment (default: default)
  --format FORMAT   Output format: csv or json (default: csv)
  --help            Show help
  --version         Show version

Examples:
  $(basename "$0") --format csv
  $(basename "$0") --format json --env prod
EOF
}

# =============================================================================
# ARGUMENTS
# =============================================================================
parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --help|-h) usage; exit 0 ;;
            --version|-v) echo "Version ${VERSION}"; exit 0 ;;
            --format) OUTPUT_FORMAT="$2"; shift ;;
            --env) ENV="$2"; shift ;;
            *) echo "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done
}

# =============================================================================
# SSH EXECUTION
# =============================================================================
run_ssh() {
    local host="$1"
    local cmd="$2"

    ssh -o BatchMode=yes "$host" "$cmd" 2>/dev/null
}

# =============================================================================
# DATA COLLECTION
# =============================================================================
collect_data() {
    local host="$1"

    echo "[INFO] Collecting data from: $host"

    hostname=$(run_ssh "$host" "hostname")
    ip=$(run_ssh "$host" "hostname -I | awk '{print \$1}'")
    os_name=$(run_ssh "$host" "uname -s")
    kernel=$(run_ssh "$host" "uname -r")
    cpu_count=$(run_ssh "$host" "nproc")
    ram=$(run_ssh "$host" "free -m | awk '/Mem:/ {print \$2\"MB\"}'")
    disk=$(run_ssh "$host" "df -h / | awk 'NR==2 {print \$4}'")
    date_now=$(date +%Y-%m-%d)

    echo "$hostname|$ip|$os_name|$kernel|$cpu_count|$ram|$disk|$date_now"
}

# =============================================================================
# OUTPUT
# =============================================================================
write_csv() {
    local data="$1"
    local file="$2"

    {
        echo "Hostname,IP,OS,Kernel,CPU,RAM,Disk,Date"
        echo "$data"
    } | tr "|" "," > "$file"

    echo "[SUCCESS] CSV saved: $file"
}

write_json() {
    local data="$1"
    local file="$2"

    IFS="|" read -r hostname ip os kernel cpu ram disk date <<< "$data"

    cat > "$file" << EOF
[
  {
    "hostname": "$hostname",
    "ip": "$ip",
    "os": "$os",
    "kernel": "$kernel",
    "cpu": "$cpu",
    "ram": "$ram",
    "disk": "$disk",
    "date": "$date"
  }
]
EOF

    echo "[SUCCESS] JSON saved: $file"
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    parse_args "$@"

    print_banner

    mkdir -p "$REPORTS_DIR"

    timestamp=$(date +%Y%m%d_%H%M%S)
    output_file="${REPORTS_DIR}/inventory_${timestamp}.${OUTPUT_FORMAT}"

    all_data=""

    for host in "${SERVERS[@]}"; do
        data=$(collect_data "$host")
        all_data+="$data"$'\n'
    done

    case "$OUTPUT_FORMAT" in
        csv) write_csv "$all_data" "$output_file" ;;
        json) write_json "$all_data" "$output_file" ;;
        *) echo "Invalid format"; exit 1 ;;
    esac

    echo "[SUCCESS] Inventory completed"
}

main "$@"
