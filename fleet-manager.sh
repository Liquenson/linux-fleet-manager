#!/usr/bin/env bash
################################################################################
# Script: fleet-manager.sh
# Description: Main entry point for Linux Fleet Manager
# Author: Liquenson Ruben Alexis
# Version: 2.1.0
################################################################################
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly VERSION="2.1.0"

# Load common library
if [[ -f "${SCRIPT_DIR}/lib/common.sh" ]]; then
    source "${SCRIPT_DIR}/lib/common.sh"
else
    echo "ERROR: Failed to load common.sh library" >&2
    exit 1
fi

# =============================================================================
# DEFAULTS
# =============================================================================
COMMAND=""
ENV="default"
FORMAT="csv"
CONFIG="${SCRIPT_DIR}/config/servers.ini"

# =============================================================================
# USAGE
# =============================================================================
usage() {
    cat << EOF
Usage: $(basename "$0") COMMAND [OPTIONS]

Linux Fleet Manager - Automate large-scale Linux infrastructure management

Commands:
  inventory       Collect server inventory and export to CSV or JSON
  health-check    Run health checks across the fleet
  backup          Execute backup operations on target servers

Options:
  --env ENV       Target environment: dev, staging, prod (default: default)
  --format FORMAT Output format: csv or json (default: csv)
  --config FILE   Path to servers config file (default: config/servers.ini)
  --help          Show this help message and exit
  --version       Show version and exit

Examples:
  $(basename "$0") inventory --format csv
  $(basename "$0") inventory --format json --env production
  $(basename "$0") health-check --env staging
  $(basename "$0") backup --env prod --config config/prod-servers.ini

EOF
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================
parse_args() {
    [[ "$#" -eq 0 ]] && { usage; exit 1; }

    # First argument must be the command
    case "$1" in
        inventory|health-check|backup)
            COMMAND="$1"
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --version|-v)
            echo "fleet-manager version ${VERSION}"
            exit 0
            ;;
        *)
            log_error "Unknown command: $1"
            usage
            exit 1
            ;;
    esac

    # Parse remaining options
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --env)
                [[ -z "${2:-}" ]] && { log_error "--env requires a value"; exit 1; }
                ENV="$2"
                shift
                ;;
            --format)
                [[ -z "${2:-}" ]] && { log_error "--format requires a value (csv|json)"; exit 1; }
                FORMAT="$2"
                shift
                ;;
            --config)
                [[ -z "${2:-}" ]] && { log_error "--config requires a file path"; exit 1; }
                CONFIG="$2"
                shift
                ;;
            --help|-h)
                usage
                exit 0
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
# COMMAND RUNNERS
# =============================================================================
run_inventory() {
    local script="${SCRIPT_DIR}/scripts/inventory/server-inventory.sh"
    [[ ! -x "$script" ]] && { log_error "inventory script not found or not executable"; exit 1; }
    log_info "Running inventory for environment: ${ENV}"
    "$script" --env "${ENV}" --format "${FORMAT}"
}

run_health_check() {
    local script="${SCRIPT_DIR}/scripts/health-check/health-check.sh"
    [[ ! -x "$script" ]] && { log_error "health-check script not found or not executable"; exit 1; }
    log_info "Running health-check for environment: ${ENV}"
    "$script" --env "${ENV}"
}

run_backup() {
    local script="${SCRIPT_DIR}/scripts/backup/backup.sh"
    [[ ! -x "$script" ]] && { log_error "backup script not found or not executable"; exit 1; }
    log_info "Running backup for environment: ${ENV}"
    "$script" --env "${ENV}" --config "${CONFIG}"
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    parse_args "$@"

    log_info "Fleet Manager v${VERSION}"
    log_info "Command  : ${COMMAND}"
    log_info "Environment : ${ENV}"
    log_info "Format   : ${FORMAT}"

    case "${COMMAND}" in
        inventory)    run_inventory   ;;
        health-check) run_health_check ;;
        backup)       run_backup      ;;
    esac
}

main "$@"
