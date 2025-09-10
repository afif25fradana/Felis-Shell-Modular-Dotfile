#!/bin/bash

# --- [Generic Hook System] ---
# A framework for registering and executing hooks for various events

# Associative array to store hooks for different events
declare -A BASHRC_HOOKS

# Function to add a hook to a specific event
# Usage: bashrc_add_hook <event_name> <function_name>
bashrc_add_hook() {
    local event_name="$1"
    local function_name="$2"
    
    # Validate inputs
    if [[ -z "$event_name" || -z "$function_name" ]]; then
        print_error "bashrc_add_hook: Both event_name and function_name are required"
        return 1
    fi
    
    # Check if function exists
    if ! declare -F "$function_name" >/dev/null; then
        print_warning "bashrc_add_hook: Function '$function_name' not found"
        return 1
    fi
    
    # Add function to the event's hook list
    if [[ -n "${BASHRC_HOOKS[$event_name]}" ]]; then
        BASHRC_HOOKS[$event_name]+=" $function_name"
    else
        BASHRC_HOOKS[$event_name]="$function_name"
    fi
    
    print_debug "Added hook '$function_name' to event '$event_name'"
}

# Function to execute all hooks for a specific event
# Usage: bashrc_run_hooks <event_name> [arguments...]
bashrc_run_hooks() {
    local event_name="$1"
    shift  # Remove event_name from arguments
    
    # Check if there are any hooks for this event
    if [[ -z "${BASHRC_HOOKS[$event_name]}" ]]; then
        return 0
    fi
    
    # Execute each hook function
    local hook
    for hook in ${BASHRC_HOOKS[$event_name]}; do
        # Check if function exists before calling it
        if declare -F "$hook" >/dev/null; then
            print_debug "Running hook '$hook' for event '$event_name'"
            "$hook" "$@"
        else
            print_warning "Hook function '$hook' for event '$event_name' not found"
        fi
    done
}

# Backward compatibility function for existing CD hooks
declare -a BASHRC_CD_HOOKS=()

# Auto-switch Node version based on .nvmrc
_fs_auto_switch_node() {
    if [[ -f ".nvmrc" ]] && command -v nvm >/dev/null; then
        local required_version
        required_version=$(cat .nvmrc)
        local current_version
        current_version=$(node --version 2>/dev/null || echo "none")

        if [[ "v$required_version" != "$current_version" ]]; then
            print_info "Switching to Node.js version: $required_version"
            nvm use "$required_version" 2>/dev/null || {
                print_warning "Node.js version $required_version not installed. Installing..."
                nvm install "$required_version" && nvm use "$required_version"
            }
        fi
    fi
}

# Enhanced Auto-Venv with Multiple Venv Managers
_fs_auto_activate_venv() {
    # Deactivate current venv if we're outside its directory
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_dir
        venv_dir=$(dirname "$VIRTUAL_ENV")
        if [[ ! "$(pwd -P)/" == "$venv_dir"/* ]]; then
            print_info "Leaving virtual environment: $(basename "$VIRTUAL_ENV")"
            deactivate 2>/dev/null || unset VIRTUAL_ENV
        fi
    fi

    # Look for virtual environments in common locations
    local venv_paths=(".venv" "venv" ".env" "env")
    local venv_found=""

    for venv_path in "${venv_paths[@]}"; do
        if [[ -d "$venv_path" && -f "$venv_path/bin/activate" ]]; then
            venv_found="$venv_path"
            break
        fi
    done

    # Activate if found and not already active
    if [[ -n "$venv_found" && -z "$VIRTUAL_ENV" ]]; then
        print_info "Activating virtual environment: $venv_found"
        source "$venv_found/bin/activate"
    fi

    # Check for Poetry environments
    if [[ -f "pyproject.toml" && -z "$VIRTUAL_ENV" ]] && command -v poetry >/dev/null; then
        if poetry env info --path >/dev/null 2>&1; then
            local poetry_venv
            poetry_venv=$(poetry env info --path 2>/dev/null)
            if [[ -n "$poetry_venv" && -f "$poetry_venv/bin/activate" ]]; then
                print_info "Activating Poetry environment"
                source "$poetry_venv/bin/activate"
            fi
        fi
    fi

    # Check for Pipenv
    if [[ -f "Pipfile" && -z "$VIRTUAL_ENV" ]] && command -v pipenv >/dev/null; then
        if pipenv --venv >/dev/null 2>&1; then
            print_info "Activating Pipenv environment"
            eval "$(pipenv shell --quiet)"
        fi
    fi

    # Check for Conda environments
    if [[ -f "environment.yml" && -z "$CONDA_DEFAULT_ENV" ]] && command -v conda >/dev/null; then
        local env_name
        env_name=$(basename "$PWD" | tr . _)
        if conda env list | grep -q "$env_name"; then
            print_info "Activating Conda environment: $env_name"
            conda activate "$env_name"
        fi
    fi
}

# Initialize CD hook system
declare -a BASHRC_CD_HOOKS=()

# Register our hook functions
BASHRC_CD_HOOKS+=('_fs_clear_git_cache_on_cd')
BASHRC_CD_HOOKS+=('_fs_auto_activate_venv')
BASHRC_CD_HOOKS+=('_fs_auto_switch_node')
BASHRC_CD_HOOKS+=('_fs_cd_show_contents')

# Function to show directory contents after cd
_fs_cd_show_contents() {
    # Show directory contents if it's small
    if [[ $(find . -maxdepth 1 -type f -type d | wc -l) -le 20 ]]; then
        if command -v eza >/dev/null; then
            eza --icons --git -F --group-directories-first
        else
            ls --color=auto -F --group-directories-first
        fi
    fi
}

# Centralized CD Function with Hook System
cd() {
    # Call the builtin cd command
    builtin cd "$@" || return $?
    
    # Execute all registered CD hooks (backward compatibility)
    local hook
    for hook in "${BASHRC_CD_HOOKS[@]}"; do
        # Check if function exists before calling it
        if declare -F "$hook" >/dev/null; then
            "$hook" "$@"
        fi
    done
    
    # Execute generic CD hooks
    bashrc_run_hooks "cd" "$@"
}

# FZF Integration
setup_fzf() {
    # Try multiple possible FZF locations
    local fzf_locations=(
        "/usr/share/fzf"
        "/usr/share/doc/fzf/examples"
        "/opt/homebrew/opt/fzf/shell"  # macOS Homebrew
        "$HOME/.fzf/shell"             # Manual install
    )

    for location in "${fzf_locations[@]}"; do
        if [[ -d "$location" ]]; then
            for script in "key-bindings.bash" "completion.bash"; do
                [[ -f "$location/$script" ]] && source "$location/$script"
            done
            break
        fi
    done

    # Enhanced FZF configuration
    export FZF_DEFAULT_OPTS="
        --height=40%
        --layout=reverse
        --border
        --inline-info
        --color=dark
        --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
        --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
    "

    # Use fd or rg if available for better performance
    if command -v fd >/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    elif command -v rg >/dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    # Alt-C for better directory navigation
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
}

setup_fzf

# Zoxide Integration (Smart CD)
if command -v zoxide >/dev/null; then
    eval "$(zoxide init bash)"

    # Override z to use our enhanced cd
    z() {
        local result
        result=$(zoxide query -- "$@") && cd "$result" || return
    }
fi

# Directory History
# Keep track of directory history for quick navigation
DIRSTACK_SIZE=20
declare -a DIRSTACK

push_dir() {
    local dir="$PWD"
    # Remove duplicates
    DIRSTACK=("${DIRSTACK[@]/$dir}")
    # Add to front
    DIRSTACK=("$dir" "${DIRSTACK[@]}")
    # Trim to size
    DIRSTACK=("${DIRSTACK[@]:0:$DIRSTACK_SIZE}")
}

# Add to PROMPT_COMMAND
if [[ "$PROMPT_COMMAND" == *"build_prompt"* ]]; then
    PROMPT_COMMAND="push_dir; $PROMPT_COMMAND"
else
    PROMPT_COMMAND="push_dir; ${PROMPT_COMMAND}"
fi

# Shell Options
# Better history handling
shopt -s histappend        # Append to history file
shopt -s checkwinsize      # Check window size after each command
shopt -s expand_aliases    # Expand aliases
shopt -s cmdhist          # Save multi-line commands in history as single line
shopt -s lithist          # Save multi-line commands with newlines

# Better globbing
shopt -s globstar         # Enable ** for recursive globbing
shopt -s nullglob         # Null globbing (empty if no matches)
shopt -s extglob          # Extended globbing
shopt -s nocaseglob       # Case-insensitive globbing

# Better completion
shopt -s cdspell          # Correct minor spelling errors in cd
shopt -s dirspell         # Correct minor spelling errors in directory names

# Completion Enhancements
# Load bash completion if available
if [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

# Startup Commands
startup_hook() {
    # Check if fastfetch is enabled (default: true)
    local fastfetch_enabled=${FASTFETCH_ENABLED:-true}
    
    if [[ "$fastfetch_enabled" != "true" ]]; then
        return 0
    fi
    
    # Clear screen and show system info with random image
    if [[ -n "$FASTFETCH_SCRIPT" && -x "$FASTFETCH_SCRIPT" ]]; then
        clear && "$FASTFETCH_SCRIPT"
    elif [[ -x "$HOME/.local/bin/random-fastfetch.sh" ]]; then
        clear && "$HOME/.local/bin/random-fastfetch.sh"
    elif command -v fastfetch >/dev/null; then
        clear && fastfetch
    elif command -v neofetch >/dev/null; then
        clear && neofetch
    elif command -v screenfetch >/dev/null; then
        clear && screenfetch
    fi
}

# Only run startup hook if this is a login shell
if shopt -q login_shell 2>/dev/null; then
    startup_hook
fi

# Register existing CD hooks with the new generic system
bashrc_add_hook "cd" "_fs_clear_git_cache_on_cd"
bashrc_add_hook "cd" "_fs_auto_activate_venv"
bashrc_add_hook "cd" "_fs_auto_switch_node"
bashrc_add_hook "cd" "_fs_cd_show_contents"

# Cleanup
unset -f setup_fzf
