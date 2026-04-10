#!/bin/bash
################################################################################
# Script: server-inventory.sh
# Description: Collect comprehensive inventory from all Linux servers
# Author: Liquenson Ruben Alexis
# Version: 1.0.0
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly PROJECT_ROOT

readonly VERSION="1.0.0"

# Load library
if [[ -f "${PROJECT_ROOT}/lib/common.sh" ]]; then
    source "${PROJECT_ROOT}/lib/common.sh"
else
    echo "ERROR: Failed to load common.sh library" >&2
    exit 1
fi

readonly REPORTS_DIR="${PROJECT_ROOT}/reports"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
readonly TIMESTAMP

OUTPUT_FORMAT="csv"
OUTPUT_FILE=""

usage() {
    cat << 'EOF'
Usage: server-inventory.sh [OPTIONS]

OPTIONS:
    -f, --format FORMAT    Output format: csv or json (default: csv)
    -o, --output FILE      Output filename
    -h, --help             Display help
    --version              Display version

EXAMPLES:
    ./server-inventory.sh
    ./server-inventory.sh --format json
EOF
}

print_version() {
    echo "Linux Fleet Manager - Server Inventory v${VERSION}"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--format)
                OUTPUT_FORMAT="$(echo "$2" | tr '[:upper:]' '[:lower:]')"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            --version)
                print_version
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

main() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║           ��� LINUX FLEET MANAGER - SERVER INVENTORY             ║
║                                                                  ║
║  Automated server discovery and inventory collection            ║
║  Author: Liquenson Ruben Alexis                                 ║
╚══════════════════════════════════════════════════════════════════╝

EOF

    parse_args "$@"

    log_info "Starting server inventory collection..."

    ensure_dir "${REPORTS_DIR}"

    [[ -z "${OUTPUT_FILE}" ]] && OUTPUT_FILE="${REPORTS_DIR}/server-inventory_${TIMESTAMP}.${OUTPUT_FORMAT}"

    log_info "Output file: ${OUTPUT_FILE}"

    # Collect data
    local hostname
    local ip
    local os_name
    local kernel
    local cpu_count
    local date_now
    
    hostname=$(hostname)
    ip="127.0.0.1"
    os_name=$(uname -s)
    kernel=$(uname -r)
    cpu_count="${NUMBER_OF_PROCESSORS:-N/A}"
    date_now=$(date +%Y-%m-%d)

    # Write output
    if [[ "${OUTPUT_FORMAT}" == "csv" ]]; then
        {
            echo "Hostname,IP Address,OS Name,Kernel,CPU Count,Last Update"
            echo "${hostname},${ip},${os_name},${kernel},${cpu_count},${date_now}"
        } > "${OUTPUT_FILE}"
    else
        cat > "${OUTPUT_FILE}" << EOF
[
  {
    "hostname": "${hostname}",
    "ip_address": "${ip}",
    "os_name": "${os_name}",
    "kernel": "${kernel}",
    "cpu_count": "${cpu_count}",
    "last_update": "${date_now}"
  }
]
EOF
    fi

    log_success "Inventory collected from localhost"
    log_success "Report saved to: ${OUTPUT_FILE}"
    log_success "✅ Script completed successfully!"
}

main "$@"
