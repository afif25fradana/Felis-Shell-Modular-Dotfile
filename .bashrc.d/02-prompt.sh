#!/bin/bash

# Configuration
PROMPT_GIT_CACHE_TIMEOUT=5  # Cache git status for 5 seconds
PROMPT_CACHE_DIR="${BASHRC_CACHE_DIR:-$HOME/.cache/bashrc}"

# Git Status Cache Function
_fs_get_git_status_cached() {
    local repo_root
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || return 1

    local cache_file
    cache_file="$PROMPT_CACHE_DIR/git_$(echo "$repo_root" | tr '/' '_')"
    local current_time
    current_time=$(date +%s)

    # Check if cache exists and is still valid
    if [[ -f "$cache_file" ]]; then
        local cache_time
        cache_time=$(stat -c %Y "$cache_file" 2>/dev/null || echo 0)
        if (( current_time - cache_time < PROMPT_GIT_CACHE_TIMEOUT )); then
            cat "$cache_file"
            return 0
        fi
    fi

    # Generate fresh git status
    local git_output branch symbol git_status=""
    git_output=$(git status --porcelain -b 2>/dev/null)

    if [[ -n "$git_output" ]]; then
        # Extract branch name
        branch=$(echo "$git_output" | head -n 1 | sed -e 's/^## //;s/\.\.\..*$//' -e 's/\[.*\]$//')

        # Handle detached HEAD
        if [[ "$branch" == "HEAD (no branch)" ]] || [[ -z "$branch" ]]; then
            branch=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
            branch="($branch)"
        fi

        # Choose symbol
        symbol="git"
        [[ "$USE_NERD_FONT" = true ]] && symbol=""

        # Check for changes (dirty repo)
        if [[ $(echo "$git_output" | wc -l) -gt 1 ]]; then
            git_status="dirty $symbol $branch"
        else
            # Check for unpushed commits
            if git rev-parse --verify HEAD >/dev/null 2>&1; then
                local unpushed
                unpushed=$(git rev-list --count "@{u}..HEAD" 2>/dev/null || echo "0")
                if [[ "$unpushed" -gt 0 ]]; then
                    git_status="ahead $symbol $branch ↑$unpushed"
                else
                    git_status="clean $symbol $branch"
                fi
            else
                git_status="clean $symbol $branch"
            fi
        fi
    fi

    # Cache the result
    echo "$git_status" > "$cache_file"
    echo "$git_status"
}

# Build Prompt Function
build_prompt() {
    local exit_code=$?

    # Prompt colors (with proper bash escaping)
    local P_RESET="\[${C_RESET}\]"
    local P_BOLD="\[${C_BOLD}\]"
    local P_GREEN="\[${C_GREEN}\]"
    local P_YELLOW="\[${C_YELLOW}\]"
    local P_BLUE="\[${C_BLUE}\]"
    local P_CYAN="\[${C_CYAN}\]"
    local P_RED="\[${C_RED}\]"
    local P_MAGENTA="\[${C_MAGENTA}\]"
    local P_GRAY="\[${C_GRAY}\]"

    # Exit Status Indicator
    local exit_status=""
    if [[ $exit_code -ne 0 ]]; then
        exit_status="${P_RED}✗ $exit_code${P_RESET} "
    fi

    # Git Status
    local git_info=""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local git_status
        git_status=$(_fs_get_git_status_cached)

        if [[ -n "$git_status" ]]; then
            read -r status symbol branch extra <<< "$git_status"
            case "$status" in
                "dirty")  git_info=" ${P_YELLOW}${symbol} ${branch}*${P_RESET}" ;;
                "ahead")  git_info=" ${P_CYAN}${symbol} ${branch} ${P_GRAY}${extra}${P_RESET}" ;;
                "clean")  git_info=" ${P_GREEN}${symbol} ${branch}${P_RESET}" ;;
            esac
        fi
    fi

    # Python Virtual Environment
    local venv_info=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name
        venv_name=$(basename "$VIRTUAL_ENV")
        local symbol="py"
        [[ "$USE_NERD_FONT" = true ]] && symbol=""
        venv_info=" ${P_YELLOW}${symbol} ${venv_name}${P_RESET}"
    fi

    # Node.js Version (if in Node project)
    local node_info=""
    if [[ -f "package.json" ]] && command -v node >/dev/null; then
        local node_version
        node_version=$(node --version 2>/dev/null)
        if [[ -n "$node_version" ]]; then
            local symbol="js"
            [[ "$USE_NERD_FONT" = true ]] && symbol=""
            node_info=" ${P_GREEN}${symbol} ${node_version#v}${P_RESET}"
        fi
    fi

    # Working Directory
    # Show abbreviated path for long directories
    local pwd_info
    if [[ ${#PWD} -gt 50 ]]; then
        pwd_info="...${PWD: -47}"
    else
        pwd_info="$PWD"
    fi

    # Replace home directory with ~
    pwd_info=${pwd_info/#$HOME/\~}

    # SSH Indicator
    local ssh_info=""
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        local symbol="ssh"
        [[ "$USE_NERD_FONT" = true ]] && symbol=""
        ssh_info="${P_MAGENTA}${symbol} ${P_RESET}"
    fi

    # Background Jobs
    local jobs_info=""
    local job_count
    job_count=$(jobs -r | wc -l)
    if [[ $job_count -gt 0 ]]; then
        local symbol="jobs"
        [[ "$USE_NERD_FONT" = true ]] && symbol=""
        jobs_info=" ${P_CYAN}${symbol} ${job_count}${P_RESET}"
    fi

    # Build Final PS1
    # Line 1: User@host, SSH indicator, working directory, git, venv, node, jobs
    # Line 2: Exit status (if non-zero), prompt symbol
    local line1="${ssh_info}${P_CYAN}\u@\h${P_RESET} ${P_BLUE}${pwd_info}${P_RESET}${git_info}${venv_info}${node_info}${jobs_info}"
    local line2="${exit_status}${P_BOLD}${P_GREEN}❯${P_RESET} "

    PS1="${line1}\n${line2}"
}

# Git Repository Change Hook
# Clear git cache when changing directories
_fs_clear_git_cache_on_cd() {
    local old_repo new_repo
    old_repo=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
    # Note: In the hook system, cd is already called by the main cd function
    new_repo=$(git rev-parse --show-toplevel 2>/dev/null || echo "")

    # If we changed repositories, clear the old cache
    if [[ "$old_repo" != "$new_repo" && -n "$old_repo" ]]; then
        local cache_file
        cache_file="$PROMPT_CACHE_DIR/git_$(echo "$old_repo" | tr '/' '_')"
        [[ -f "$cache_file" ]] && rm -f "$cache_file"
    fi
}

# Set the prompt command
PROMPT_COMMAND=build_prompt

# Cleanup
# Clean old cache files on startup (older than 1 day)
if [[ -d "$PROMPT_CACHE_DIR" ]]; then
    find "$PROMPT_CACHE_DIR" -name "git_*" -mtime +1 -delete 2>/dev/null || true
fi
