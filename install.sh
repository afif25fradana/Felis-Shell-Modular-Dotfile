#!/bin/bash
#
# install.sh - Dotfiles Installation Script for Felis-Shell
#

# Exit immediately if a command exits with a non-zero status.
set -e

# --- [COLORS] ---
# Check if terminal supports colors
if [[ -t 1 ]] && command -v tput >/dev/null && tput colors >/dev/null 2>&1 && [[ $(tput colors) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    # No color support
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# --- [HELPER FUNCTIONS] ---
print_info() { echo -e "${BLUE}ℹ${NC} $*"; }
print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_error() { echo -e "${RED}✗${NC} $*" >&2; }

# --- [FUNCTIONS] ---

# Backup existing files
backup_file() {
    local file="$1"
    local backup
    
    # Dry run mode - just show what would be done
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        if [[ -e "$HOME/$file" ]]; then
            echo "  Would backup: $HOME/$file"
        fi
        return 0
    fi
    
    if [[ -e "$HOME/$file" ]]; then
        backup="$HOME/${file}.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Debug information
        if [[ "${DEBUG:-false}" == "true" ]]; then
            echo "  Debug: Backing up $HOME/$file to $backup"
        fi
        
        print_warning "Backing up existing '$file' to '$backup'"
        mv "$HOME/$file" "$backup"
    fi
}

# Create symlinks for dotfiles
install_dotfile() {
    local source="$1"
    local target="$2"
    
    # Dry run mode - just show what would be done
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        echo "  Would install: $target"
        echo "    From: $source"
        return 0
    fi
    
    # Debug information
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo "  Debug: Source: $source"
        echo "  Debug: Target: $target"
        echo "  Debug: Target directory: $(dirname "$target")"
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    if ln -sf "$source" "$target"; then
        print_success "Installed $target"
    else
        print_error "Failed to install $target"
        return 1
    fi
}

# Copy files (for binary files like images)
copy_file() {
    local source="$1"
    local target="$2"
    
    # Dry run mode - just show what would be done
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        echo "  Would copy: $target"
        echo "    From: $source"
        return 0
    fi
    
    # Debug information
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo "  Debug: Source: $source"
        echo "  Debug: Target: $target"
        echo "  Debug: Target directory: $(dirname "$target")"
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Copy file
    if cp "$source" "$target"; then
        print_success "Copied $target"
    else
        print_error "Failed to copy $target"
        return 1
    fi
}

# The main installation function
install_dotfiles() {
    local repo_root
    repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    
    # Show what will be done in dry-run mode
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        echo "=== DRY RUN MODE ==="
        echo "No files will be modified. This is what would happen:"
        echo
    fi
    
    # Show debug information if enabled
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo "=== DEBUG MODE ==="
        echo "Repository root: $repo_root"
        echo "Home directory: $HOME"
        echo
    fi

    # --- User Confirmation ---
    if [[ "${DRY_RUN:-false}" != "true" ]]; then
        print_warning "This script will back up and replace existing dotfiles in your home directory."
        read -p "Do you want to proceed with the installation? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled."
            exit 1
        fi
    else
        echo "=== Skipping user confirmation in dry-run mode ==="
        echo
    fi

    print_info "Installing Felis-Shell dotfiles..."
    
    # --- Installation ---
    
    # Install root-level dotfiles
    for file in .bashrc .gitconfig .inputrc .editorconfig; do
        if [[ -f "$repo_root/$file" ]]; then
            backup_file "$file"
            install_dotfile "$repo_root/$file" "$HOME/$file"
        fi
    done
    
    # Install .bashrc.d directory
    backup_file ".bashrc.d"
    install_dotfile "$repo_root/.bashrc.d" "$HOME/.bashrc.d"
    
    # Install .config directory contents
    if [[ -d "$repo_root/.config" ]]; then
        mkdir -p "$HOME/.config"
        for config_item in "$repo_root/.config/kitty/"*; do
            local item_name
            item_name=$(basename "$config_item")
            backup_file ".config/kitty/$item_name"
            install_dotfile "$config_item" "$HOME/.config/kitty/$item_name"
        done
    fi
    
    # Install .local/bin directory contents
    mkdir -p "$HOME/.local/bin"
    
    # Install random-fastfetch.sh script
    if [[ -f "$repo_root/random-fastfetch.sh" ]]; then
        backup_file ".local/bin/random-fastfetch.sh"
        install_dotfile "$repo_root/random-fastfetch.sh" "$HOME/.local/bin/random-fastfetch.sh"
    fi
    
    # Install other scripts in .local/bin directory
    if [[ -d "$repo_root/.local/bin" ]]; then
        for bin_item in "$repo_root/.local/bin/"*; do
            if [[ -f "$bin_item" ]]; then
                local item_name
                item_name=$(basename "$bin_item")
                # Skip random-fastfetch.sh as it's handled separately
                if [[ "$item_name" != "random-fastfetch.sh" ]]; then
                    backup_file ".local/bin/$item_name"
                    install_dotfile "$bin_item" "$HOME/.local/bin/$item_name"
                fi
            fi
        done
    fi
    
    # Install logos directory
    if [[ -d "$repo_root/logos" ]]; then
        # Create logos directory in ~/.dotfiles
        mkdir -p "$HOME/.dotfiles/logos"
        for logo_file in "$repo_root/logos/"*; do
            if [[ -f "$logo_file" ]]; then
                local logo_name
                logo_name=$(basename "$logo_file")
                backup_file ".dotfiles/logos/$logo_name"
                copy_file "$logo_file" "$HOME/.dotfiles/logos/$logo_name"
            fi
        done
    fi
    
    # --- Finalization ---
    if [[ "${DRY_RUN:-false}" != "true" ]]; then
        print_success "Felis-Shell dotfiles installation complete!"
        print_info "Please restart your terminal or run 'source ~/.bashrc' to apply the changes."
    else
        echo "=== DRY RUN COMPLETE ==="
        echo "No files were actually modified."
    fi
    
    # --- Dependency Information ---
    if [[ "${DRY_RUN:-false}" != "true" ]]; then
        echo
        print_warning "For the best experience, please ensure these dependencies are installed:"
        echo
        echo -e "  ${BLUE}--- Core CLI Tools ---${NC}"
        echo -e "    • ${GREEN}eza${NC}: Modern replacement for 'ls'"
        echo -e "    • ${GREEN}bat${NC}: A 'cat' clone with syntax highlighting"
        echo -e "    • ${GREEN}fd${NC}: A simple, fast and user-friendly alternative to 'find'"
        echo -e "    • ${GREEN}ripgrep (rg)${NC}: A line-oriented search tool"
        echo -e "    • ${GREEN}fzf${NC}: A command-line fuzzy finder"
        echo -e "    • ${GREEN}zoxide${NC}: A smarter 'cd' command"
        echo -e "    • ${GREEN}btop${NC} or ${GREEN}htop${NC}: Modern system monitors"
        echo -e "    • ${GREEN}jq${NC}: A lightweight and flexible command-line JSON processor"
        echo -e "    • ${GREEN}unzip${NC}, ${GREEN}unrar${NC}, ${GREEN}p7zip${NC}: For the 'extract' function"
        echo -e "    • ${GREEN}bzip2${NC}, ${GREEN}gzip${NC}, ${GREEN}ncompress${NC}, ${GREEN}cabextract${NC}, ${GREEN}xz-utils${NC}: Additional tools for the 'extract' function"
        echo
        echo -e "  ${BLUE}--- Development ---${NC}"
        echo -e "    • ${GREEN}nvm${NC}: Node Version Manager"
        echo -e "    • ${GREEN}shellcheck${NC}: Linter for shell scripts"
        echo -e "    • ${GREEN}docker${NC} and ${GREEN}docker-compose${NC}: For the n8n functions and Docker aliases"
        echo -e "    • ${GREEN}ngrok${NC}: For the n8n-ngrok function"
        echo -e "    • ${GREEN}yay${NC} or ${GREEN}paru${NC}: An AUR helper (Arch Linux specific)"
        echo
        echo -e "  ${BLUE}--- Terminal & Appearance ---${NC}"
        echo -e "    • ${GREEN}kitty${NC}: The recommended terminal emulator"
        echo -e "    • ${GREEN}Nerd Fonts${NC} (e.g., JetBrains Mono Nerd Font): For icons in the prompt"
        echo -e "    • ${GREEN}fastfetch${NC} or ${GREEN}neofetch${NC}: For the welcome screen"
        echo -e "    • ${GREEN}cowsay${NC} and ${GREEN}fortune${NC}: For the 'wisdom' alias"
        echo
        echo -e "  ${YELLOW}Package Installation Commands by Distribution:${NC}"
        echo -e "  ${BLUE}Arch Linux:${NC}"
        echo -e "  ${NC}sudo pacman -S eza bat fd ripgrep fzf zoxide btop kitty fastfetch shellcheck jq unzip unrar p7zip cowsay fortune docker bzip2 gzip ncompress xz cabextract${NC}"
        echo -e "  ${NC}# Note: Enable and start the docker service with: sudo systemctl enable --now docker${NC}"
        echo -e "  ${NC}# Note: ngrok is not available in the official repositories. Install from AUR or the ngrok website.${NC}"
        echo
        echo -e "  ${BLUE}Ubuntu/Debian:${NC}"
        echo -e "  ${NC}sudo apt install eza bat fd-find ripgrep fzf zoxide btop kitty fastfetch shellcheck jq unzip unrar p7zip cowsay fortune docker docker-compose bzip2 gzip ncompress xz-utils cabextract${NC}"
        echo -e "  ${NC}# Note: Enable and start the docker service with: sudo systemctl enable --now docker${NC}"
        echo -e "  ${NC}# Note: ngrok is not available in the official repositories. Install from the ngrok website.${NC}"
        echo
        echo -e "  ${BLUE}Note:${NC} On Ubuntu/Debian, you may need to symlink 'bat' and 'fd' commands:"
        echo -e "  ${NC}mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat && ln -s /usr/bin/fdfind ~/.local/bin/fd${NC}"
        echo
    fi
}

# --- [MAIN EXECUTION] ---
# Run the installation function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|-n)
                DRY_RUN=true
                shift
                ;;
            --debug|-d)
                DEBUG=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo "Install Felis-Shell dotfiles."
                echo
                echo "Options:"
                echo "  -n, --dry-run  Show what would be done without making changes"
                echo "  -d, --debug    Show debug information during installation"
                echo "  -h, --help     Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
    
    install_dotfiles
fi
