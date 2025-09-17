#!/bin/bash

# Exit if not running interactively
[[ $- != *i* ]] && return

# Check for minimum bash version
if ((BASH_VERSINFO[0] < 4)); then
    echo "Warning: Some features may not work properly with Bash versions below 4.0" >&2
fi

# --- [USER CONFIG] ---
# Default configuration
export USE_NERD_FONT=${USE_NERD_FONT:-true}
export FELIS_SHELL_DEBUG=${FELIS_SHELL_DEBUG:-false}
export FELIS_SHELL_VERBOSE=${FELIS_SHELL_VERBOSE:-false}

# --- [CORE SETUP] ---
BASHRC_CACHE_DIR="$HOME/.cache/bashrc"
mkdir -p "$BASHRC_CACHE_DIR"

BASHRC_DIR="$HOME/.bashrc.d"
if [[ ! -d "$BASHRC_DIR" ]]; then
    echo "Warning: $BASHRC_DIR directory not found" >&2
    return 1
fi

# Load user configuration if it exists
if [[ -r "$BASHRC_DIR/user.conf" ]]; then
    # shellcheck source=/dev/null
    if ! source "$BASHRC_DIR/user.conf"; then
        echo "Error: Failed to load user configuration" >&2
    fi
fi

# Define module loading order
declare -a MODULE_ORDER=(
    "00" # Colors and basic setup
    "01" # Aliases
    "02" # Prompt configuration
    "03" # Hooks and extensions
)

# Load core modules in order
for prefix in "${MODULE_ORDER[@]}"; do
    while IFS= read -r -d '' file; do
        if [[ -r "$file" ]]; then
            # shellcheck source=/dev/null
            if ! source "$file"; then
                echo "Error: Failed to load module $file" >&2
            elif [[ "${FELIS_SHELL_DEBUG}" == "true" ]]; then
                echo "Debug: Loaded module $file"
            fi
        fi
    done < <(find "$BASHRC_DIR" -maxdepth 1 -type f -name "${prefix}-*.sh" -print0 2>/dev/null)
    
    if [[ -d "$BASHRC_DIR/functions" ]]; then
        for file in "$BASHRC_DIR"/functions/*.sh; do
            [[ -r "$file" ]] && source "$file"
        done
        unset file
    fi
    unset file
done

# --- [NVM CONFIGURATION] ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
