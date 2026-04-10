#!/bin/bash
################################################################################
# Library: common.sh
# Description: Common utility functions for Linux Fleet Manager
# Author: Liquenson Ruben Alexis
# Version: 1.0.0
################################################################################

# Prevent multiple sourcing
[[ -n "${LFM_COMMON_LOADED:-}" ]] && return 0
readonly LFM_COMMON_LOADED=true

# =============================================================================
# CONSTANTS
# =============================================================================
readonly LFM_LIB_VERSION="1.0.0"

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1
readonly EXIT_INVALID_ARGS=2

# =============================================================================
# COLOR CODES
# =============================================================================
if [[ -t 1 ]]; then
    readonly COLOR_RESET='\033[0m'
    readonly COLOR_RED='\033[0;31m'
    readonly COLOR_GREEN='\033[0;32m'
    readonly COLOR_YELLOW='\033[1;33m'
    readonly COLOR_BLUE='\033[0;34m'
    readonly COLOR_MAGENTA='\033[0;35m'
    readonly COLOR_CYAN='\033[0;36m'
    readonly COLOR_BOLD='\033[1m'
else
    readonly COLOR_RESET=''
    readonly COLOR_RED=''
    readonly COLOR_GREEN=''
    readonly COLOR_YELLOW=''
    readonly COLOR_BLUE=''
    readonly COLOR_MAGENTA=''
    readonly COLOR_CYAN=''
    readonly COLOR_BOLD=''
fi

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Print error and exit
die() {
    local message="${1:-An error occurred}"
    local exit_code="${2:-${EXIT_ERROR}}"
    echo -e "${COLOR_RED}[FATAL]${COLOR_RESET} ${message}" >&2
    exit "${exit_code}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required dependencies
check_dependencies() {
    local missing_deps=()
    for cmd in "$@"; do
        if ! command_exists "${cmd}"; then
            missing_deps+=("${cmd}")
        fi
    done
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        die "Missing dependencies: ${missing_deps[*]}"
    fi
}

# Get script directory
get_script_dir() {
    local source="${BASH_SOURCE[1]}"
    while [[ -h "${source}" ]]; do
        local dir="$(cd -P "$(dirname "${source}")" && pwd)"
        source="$(readlink "${source}")"
        [[ ${source} != /* ]] && source="${dir}/${source}"
    done
    cd -P "$(dirname "${source}")" && pwd
}

# Get project root
get_project_root() {
    local dir="$(get_script_dir)"
    while [[ "${dir}" != "/" ]]; do
        if [[ -f "${dir}/.git/config" ]] || [[ -f "${dir}/README.md" ]]; then
            echo "${dir}"
            return 0
        fi
        dir="$(dirname "${dir}")"
    done
    echo "."
}

# Trim whitespace
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "${var}"
}

# Convert to lowercase
to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Convert to uppercase
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Check if variable is set
is_set() {
    [[ -n "${1:-}" ]]
}

# Get timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Get timestamp (filename-safe)
get_timestamp_safe() {
    date '+%Y%m%d_%H%M%S'
}

# Create directory if not exists
ensure_dir() {
    local dir="$1"
    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}" || die "Failed to create directory: ${dir}"
    fi
}

# Check if running as root
is_root() {
    [[ ${EUID} -eq 0 ]]
}

# =============================================================================
# LOGGING FUNCTIONS
# =============================================================================

log_info() {
    echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $*"
}

log_success() {
    echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $*"
}

log_warning() {
    echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $*"
}

log_error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $*" >&2
}

log_debug() {
    if [[ "${LFM_DEBUG:-false}" == "true" ]]; then
        echo -e "${COLOR_MAGENTA}[DEBUG]${COLOR_RESET} $*" >&2
    fi
}

# =============================================================================
# INITIALIZATION
# =============================================================================
set -euo pipefail

export -f die command_exists log_info log_success log_warning log_error
