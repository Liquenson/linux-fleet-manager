#!/bin/bash
################################################################################
# Library: logger.sh
# Description: Advanced logging system for Linux Fleet Manager
# Author: Liquenson Ruben Alexis
# Version: 1.0.0
################################################################################

[[ -n "${LFM_LOGGER_LOADED:-}" ]] && return 0
readonly LFM_LOGGER_LOADED=true

# Source common library
source "$(dirname "${BASH_SOURCE[0]}")/common.sh" 2>/dev/null || true

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================
LOG_LEVEL="${LFM_LOG_LEVEL:-INFO}"
LOG_FILE="${LFM_LOG_FILE:-/tmp/lfm.log}"
ENABLE_FILE_LOG="${LFM_ENABLE_FILE_LOG:-true}"

# =============================================================================
# LOGGING FUNCTIONS
# =============================================================================

# Write log to file
write_log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    
    if [[ "${ENABLE_FILE_LOG}" == "true" ]]; then
        echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
    fi
}

# Log with level
logger_log() {
    local level="$1"
    shift
    write_log "${level}" "$@"
}
