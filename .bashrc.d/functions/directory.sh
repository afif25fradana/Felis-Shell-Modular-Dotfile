#!/bin/bash
#
# ~/.bashrc.d/functions/directory.sh - Directory Functions
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- Enhanced Directory Functions ---

# Creates a new directory and immediately changes the current working directory to it.
#
# This function combines the `mkdir` and `cd` commands into a single, convenient utility.
# It simplifies the common workflow of creating a new directory and then navigating into it,
# saving time and reducing the number of commands you need to type.
#
# @param $1 - The name of the directory to create. This is a required parameter.
#
# @example
#   mkcd my-new-project
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
