#!/bin/bash
#
# ~/.bashrc.d/functions/dotfiles.sh - Dotfiles Management
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- Dotfiles Management ---

# Manages the backup and restoration of dotfiles, simplifying the process of saving and
# reloading your shell configuration.
#
# This function provides two main actions: `backup` and `restore`. The `backup` action copies
# your current dotfiles to the `~/.dotfiles` directory and initializes a Git repository for
# version control. The `restore` action copies the files from `~/.dotfiles` back to your
# home directory, allowing you to quickly restore your configuration on a new machine.
#
# @param $1 - The action to perform. Can be either `backup` or `restore`.
#
# @example
#   dotfiles backup
#   dotfiles restore
dotfiles() {
    local action="$1"
    local dotfiles_dir="$HOME/.dotfiles"
    
    # Check if color functions are available, if not define them
    if ! command -v print_info >/dev/null 2>&1; then
        # Define fallback print functions if not available
        print_success() { echo -e "✓ $*"; }
        print_warning() { echo -e "⚠ $*" >&2; }
        print_error() { echo -e "✗ $*" >&2; }
        print_info() { echo -e "ℹ $*"; }
    fi
    
    case "$action" in
        "backup")
            print_info "Backing up dotfiles..."
            mkdir -p "$dotfiles_dir"
            
            # Backup main files
            cp ~/.bashrc "$dotfiles_dir/"
            [[ -f ~/.gitconfig ]] && cp ~/.gitconfig "$dotfiles_dir/"
            [[ -f ~/.inputrc ]] && cp ~/.inputrc "$dotfiles_dir/"
            [[ -f ~/.editorconfig ]] && cp ~/.editorconfig "$dotfiles_dir/"
            
            # Backup bashrc.d directory (excluding QWEN.md)
            mkdir -p "$dotfiles_dir/.bashrc.d"
            for file in ~/.bashrc.d/*; do
                filename=$(basename "$file")
                # Skip QWEN.md as it's session context only
                if [[ "$filename" != "QWEN.md" ]]; then
                    if [[ -d "$file" ]]; then
                        cp -r "$file" "$dotfiles_dir/.bashrc.d/"
                    else
                        cp "$file" "$dotfiles_dir/.bashrc.d/"
                    fi
                fi
            done
            
            # Backup .config directory (only specific configs)
            if [[ -d ~/.config/kitty ]]; then
                mkdir -p "$dotfiles_dir/.config/kitty"
                [[ -f ~/.config/kitty/kitty.conf ]] && cp ~/.config/kitty/kitty.conf "$dotfiles_dir/.config/kitty/"
            fi
            
            # Initialize git repo if it doesn't exist
            if [[ ! -d "$dotfiles_dir/.git" ]]; then
                if command -v git >/dev/null 2>&1; then
                    (
                        cd "$dotfiles_dir" && \
                        git init && \
                        git add . && \
                        git commit -m "Initial dotfiles backup"
                    ) || print_warning "Failed to initialize git repository"
                    print_info "Initialized git repository in $dotfiles_dir"
                else
                    print_warning "Git not available, skipping repository initialization"
                fi
            else
                if command -v git >/dev/null 2>&1; then
                    (
                        cd "$dotfiles_dir" && \
                        git add . && \
                        git commit -m "Dotfiles backup update"
                    ) || print_warning "Failed to commit changes to git repository"
                fi
            fi
            
            print_success "Dotfiles backed up to $dotfiles_dir"
            ;;
        "restore")
            print_info "Restoring dotfiles..."
            
            # Restore main files
            [[ -f "$dotfiles_dir/.bashrc" ]] && cp "$dotfiles_dir/.bashrc" ~/
            [[ -f "$dotfiles_dir/.gitconfig" ]] && cp "$dotfiles_dir/.gitconfig" ~/
            [[ -f "$dotfiles_dir/.inputrc" ]] && cp "$dotfiles_dir/.inputrc" ~/
            [[ -f "$dotfiles_dir/.editorconfig" ]] && cp "$dotfiles_dir/.editorconfig" ~/
            
            # Restore bashrc.d directory
            [[ -d "$dotfiles_dir/.bashrc.d" ]] && cp -r "$dotfiles_dir/.bashrc.d" ~/
            
            # Restore .config directory
            if [[ -d "$dotfiles_dir/.config" ]]; then
                mkdir -p ~/.config
                [[ -d "$dotfiles_dir/.config/kitty" ]] && cp -r "$dotfiles_dir/.config/kitty" ~/.config/
            fi
            
            print_success "Dotfiles restored"
            print_info "You may need to run 'source ~/.bashrc' to reload the configuration"
            ;;
        *)
            print_error "Usage: dotfiles <backup|restore>"
            print_info "  backup  - Backup current dotfiles to ~/.dotfiles/"
            print_info "  restore - Restore dotfiles from ~/.dotfiles/"
            ;;
    esac
}

# Creates a new GitHub issue from the command line using the GitHub CLI.
#
# This function provides a convenient wrapper around the `gh issue create` command, allowing
# you to quickly create a new issue without leaving your terminal. It requires the GitHub CLI
# (`gh`) to be installed and authenticated.
#
# @param $1 - The title of the issue. This is a required parameter.
# @param $2 - (Optional) The body of the issue. If not provided, the issue will be created
#             with an empty body.
#
# @example
#   ghissue "Fix a bug" "This is a critical bug that needs to be fixed."
#   ghissue "Add a new feature"
ghissue() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: ghissue <title> [body]"
        return 1
    fi

    local title="$1"
    local body="${2:-}"

    if ! command -v gh >/dev/null; then
        print_error "GitHub CLI (gh) not installed"
        return 1
    fi

    if [[ -n "$body" ]]; then
        gh issue create --title "$title" --body "$body"
    else
        gh issue create --title "$title"
    fi
}

# Provides a quick overview of the current Git repository's status, including uncommitted
# changes, unpushed commits, and recent issues.
#
# This function uses the GitHub CLI (`gh`) to fetch information about the repository and
# display it in a concise, easy-to-read format. It's a useful tool for quickly checking
# the state of your project without running multiple Git commands.
#
# @example
#   ghstatus
ghstatus() {
    if ! command -v gh >/dev/null; then
        print_error "GitHub CLI (gh) not installed"
        return 1
    fi

    print_info "Repository Status:"
    
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        print_error "Not in a git repository"
        return 1
    fi
    
    # Get repository info
    local repo_name
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
    
    echo -e "${C_CYAN}Repository:${C_RESET} $repo_name"
    
    # Check for uncommitted changes
    if [[ -n "$(git status --porcelain)" ]]; then
        print_warning "You have uncommitted changes"
    else
        print_success "Working directory is clean"
    fi
    
    # Check for unpushed commits
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        local unpushed
        unpushed=$(git rev-list --count "@{u}..HEAD" 2>/dev/null || echo "0")
        if [[ "$unpushed" -gt 0 ]]; then
            print_warning "You have $unpushed unpushed commits"
        fi
    fi
    
    # Show recent issues
    print_info "Recent Issues:"
    gh issue list --limit 5 2>/dev/null || echo "No issues or not connected to GitHub"
}
