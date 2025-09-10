#!/bin/bash

if [[ -t 1 ]] && command -v tput >/dev/null && tput colors >/dev/null 2>&1; then
    COLORS=$(tput colors 2>/dev/null || echo 0)

    if (( COLORS >= 256 )); then
        # 256-color support
        export C_RESET='\e[0m'
        export C_BOLD='\e[1m'
        export C_DIM='\e[2m'

        export C_RED='\e[38;5;197m'      # Soft red
        export C_GREEN='\e[38;5;114m'    # Mint green
        export C_YELLOW='\e[38;5;221m'   # Warm yellow
        export C_BLUE='\e[38;5;75m'      # Sky blue
        export C_MAGENTA='\e[38;5;213m'  # Sweet pink
        export C_CYAN='\e[38;5;87m'      # Aqua cyan
        export C_WHITE='\e[38;5;254m'    # Soft white
        export C_GRAY='\e[38;5;243m'     # Medium gray
        export C_DARK_GRAY='\e[38;5;237m' # Dark gray

        # Semantic colors
        export C_SUCCESS="$C_GREEN"
        export C_WARNING="$C_YELLOW"
        export C_ERROR="$C_RED"
        export C_INFO="$C_BLUE"
        export C_MUTED="$C_GRAY"

    elif (( COLORS >= 8 )); then
        # Fallback to 8-color
        export C_RESET='\e[0m'
        export C_BOLD='\e[1m'
        export C_DIM='\e[2m'
        export C_RED='\e[31m'
        export C_GREEN='\e[32m'
        export C_YELLOW='\e[33m'
        export C_BLUE='\e[34m'
        export C_MAGENTA='\e[35m'
        export C_CYAN='\e[36m'
        export C_WHITE='\e[37m'
        export C_GRAY='\e[90m'
        export C_DARK_GRAY='\e[90m'
        export C_SUCCESS="$C_GREEN"
        export C_WARNING="$C_YELLOW"
        export C_ERROR="$C_RED"
        export C_INFO="$C_BLUE"
        export C_MUTED="$C_GRAY"
    fi
else
    # No color support
    export C_RESET='' C_BOLD='' C_DIM=''
    export C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN='' C_WHITE='' C_GRAY='' C_DARK_GRAY=''
    export C_SUCCESS='' C_WARNING='' C_ERROR='' C_INFO='' C_MUTED=''
fi

# Helper functions for consistent messaging
print_success() { echo -e "${C_SUCCESS}✓${C_RESET} $*"; }
print_warning() { echo -e "${C_WARNING}⚠${C_RESET} $*"; }
print_error() { echo -e "${C_ERROR}✗${C_RESET} $*" >&2; }
print_info() { echo -e "${C_INFO}ℹ${C_RESET} $*"; }

# Enhanced Error Handling
print_debug() {
    [[ "${BASHRC_DEBUG:-false}" == "true" ]] && echo -e "${C_GRAY}🐛 DEBUG:${C_RESET} $*" >&2
}