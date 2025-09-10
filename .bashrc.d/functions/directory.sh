#!/bin/bash
#
# ~/.bashrc.d/functions/directory.sh - Directory Functions
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- Enhanced Directory Functions ---
mkcd() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: mkcd <directory>"
        return 1
    fi

    local dir="$1"
    if mkdir -p "$dir" 2>/dev/null; then
        cd "$dir" || return 1
        print_success "Created and entered directory: $dir"
    else
        print_error "Failed to create directory: $dir"
        return 1
    fi
}