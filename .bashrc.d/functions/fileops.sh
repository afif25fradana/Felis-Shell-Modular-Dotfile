#!/bin/bash
#
# ~/.bashrc.d/functions/fileops.sh - File Operations
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- File Operations ---

# Extracts a wide variety of archive formats automatically based on file extension.
#
# This function eliminates the need to remember different extraction commands for different
# archive formats. It automatically detects the file type and uses the appropriate tool to
# extract the contents, supporting formats like .tar.gz, .zip, .rar, and many more.
#
# @param $1 - The path to the archive file to extract. This is a required parameter.
#
# @example
#   extract my-archive.tar.gz
#   extract documents.zip
#   extract data.rar
extract() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: extract <archive_file>"
        return 1
    fi

    local file="$1"

    if [[ ! -f "$file" ]]; then
        print_error "File not found: $file"
        return 1
    fi

    case "${file,,}" in
        *.tar.bz2)   tar xjf "$file"     ;;
        *.tar.gz)    tar xzf "$file"     ;;
        *.bz2)       bunzip2 "$file"     ;;
        *.rar)       unrar x "$file"     ;;
        *.gz)        gunzip "$file"      ;;
        *.tar)       tar xf "$file"      ;;
        *.tbz2)      tar xjf "$file"     ;;
        *.tgz)       tar xzf "$file"     ;;
        *.zip)       unzip "$file"       ;;
        *.Z)         uncompress "$file"  ;;
        *.7z)        7z x "$file"        ;;
        *.xz)        unxz "$file"        ;;
        *.exe)       cabextract "$file"  ;;
        *)           print_error "Unknown archive format: $file" ;;
    esac
}

# Development Environment Status
devstatus() {
    echo -e "${C_BOLD}${C_YELLOW}🔧 Development Environment Status${C_RESET}
"
    
    # Git status
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${C_GREEN}📁 Repository:${C_RESET} $(basename "$(git rev-parse --show-toplevel)")"
        echo -e "${C_BLUE}🌿 Branch:${C_RESET} $(git branch --show-current)"
        local changes
        changes=$(git status --porcelain | wc -l)
        [[ $changes -gt 0 ]] && echo -e "${C_YELLOW}📝 Changes:${C_RESET} $changes files"
    fi
    
    # Virtual environments
    [[ -n "$VIRTUAL_ENV" ]] && echo -e "${C_MAGENTA}🐍 Python:${C_RESET} $(basename "$VIRTUAL_ENV")"
    [[ -n "$NODE_VERSION" ]] && echo -e "${C_GREEN}📦 Node:${C_RESET} $NODE_VERSION"
    
    # Docker status
    if command -v docker >/dev/null && docker info &>/dev/null; then
        local containers
        containers=$(docker ps -q | wc -l)
        echo -e "${C_CYAN}🐳 Docker:${C_RESET} $containers containers running"
    fi
}

# Enhanced file operations for development
backup() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: backup <file_or_directory>"
        return 1
    fi

    local target="$1"
    local backup
    backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"

    if [[ -e "$target" ]]; then
        if cp -r "$target" "$backup"; then
            print_success "Backup created: $backup"
        else
            print_error "Failed to create backup"
            return 1
        fi
    else
        print_error "File or directory not found: $target"
        return 1
    fi
}