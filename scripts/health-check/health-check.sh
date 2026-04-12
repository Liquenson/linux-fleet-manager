#!/usr/bin/env bash
################################################################################
# Script: health-check.sh
# Description: Run health checks across the fleet
# Author: Liquenson Ruben Alexis
# Version: 1.1.0
################################################################################
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly SCRIPT_DIR PROJECT_ROOT
readonly VERSION="1.1.0"

if [[ -f "${PROJECT_ROOT}/lib/common.sh" ]]; then
    source "${PROJECT_ROOT}/lib/common.sh"
else
    echo "ERROR: common.sh not found" >&2
    exit 1
fi

# =============================================================================
# DEFAULTS
# =============================================================================
ENV="default"

# =============================================================================
# USAGE
# =============================================================================
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Run health checks on the local system or fleet.

Options:
  --env ENV     Target environment (default: default)
  --help        Show this help message and exit
  --version     Show version and exit

Examples:
  $(basename "$0")
  $(basename "$0") --env production
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
                echo "health-check.sh version ${VERSION}"
                exit 0
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
# HEALTH CHECKS
# =============================================================================
check_system() {
    local os
    os=$(uname)

    log_info "Environment : ${ENV}"
    log_info "OS detected : ${os}"
    log_info "Hostname    : $(hostname)"
    log_info "Uptime      : $(uptime)"

    log_info "--- Disk Usage ---"
    df -h

    if [[ "$os" == "Linux" ]]; then
        log_info "--- Memory ---"
        free -m
        log_info "--- CPU Load ---"
        cat /proc/loadavg
    elif [[ "$os" == "Darwin" ]]; then
        log_info "--- Memory ---"
        vm_stat | head -10
    else
        log_warning "Limited checks available on: ${os}"
    fi
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    parse_args "$@"
    log_info "Starting health check..."
    check_system
    log_success "Health check completed"
}

main "$@"