#!/bin/bash

# [[ $- != *i* ]] && return

# --- [USER CONFIG] ---
export USE_NERD_FONT=true

# --- [CORE SETUP] ---
BASHRC_CACHE_DIR="$HOME/.cache/bashrc"
mkdir -p "$BASHRC_CACHE_DIR"

BASHRC_DIR="$HOME/.bashrc.d"
if [[ -d "$BASHRC_DIR" ]]; then
    # Load user configuration if it exists
    if [[ -r "$BASHRC_DIR/user.conf" ]]; then
        source "$BASHRC_DIR/user.conf"
    fi
    
    for file in "$BASHRC_DIR"/00-*.sh "$BASHRC_DIR"/01-*.sh "$BASHRC_DIR"/02-*.sh "$BASHRC_DIR"/03-*.sh; do
        if [[ -r "$file" ]]; then
            source "$file"
        elif [[ "$file" != *"**"* ]]; then
            echo "Warning: Cannot read $file" >&2
        fi
    done
    
    if [[ -d "$BASHRC_DIR/functions" ]]; then
        for file in "$BASHRC_DIR"/functions/*.sh; do
            [[ -r "$file" ]] && source "$file"
        done
        unset file
    fi
    unset file
else
    echo "Warning: $BASHRC_DIR directory not found" >&2
fi

# --- [NVM CONFIGURATION] ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
