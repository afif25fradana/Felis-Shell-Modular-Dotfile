#!/bin/bash
#
# install.sh - Dotfiles Installation Script for Felis-Shell
#

# Exit immediately if a command exits with a non-zero status.
set -e

# --- [COLORS] ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    if [[ -e "$HOME/$file" ]]; then
        backup="$HOME/${file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing '$file' to '$backup'"
        mv "$HOME/$file" "$backup"
    fi
}

# Create symlinks for dotfiles
install_dotfile() {
    local source="$1"
    local target="$2"
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    print_success "Installed $target"
}

# The main installation function
install_dotfiles() {
    local repo_root
    repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    # --- User Confirmation ---
    print_warning "This script will back up and replace existing dotfiles in your home directory."
    read -p "Do you want to proceed with the installation? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled."
        exit 1
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
        for config_item in "$repo_root/.config/"*; do
            local item_name
            item_name=$(basename "$config_item")
            backup_file ".config/$item_name"
            install_dotfile "$config_item" "$HOME/.config/$item_name"
        done
    fi
    
    # Install .local/bin directory contents
    if [[ -d "$repo_root/.local/bin" ]]; then
        mkdir -p "$HOME/.local/bin"
        for bin_item in "$repo_root/.local/bin/"*; do
            if [[ -f "$bin_item" ]]; then
                local item_name
                item_name=$(basename "$bin_item")
                backup_file ".local/bin/$item_name"
                install_dotfile "$bin_item" "$HOME/.local/bin/$item_name"
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
                install_dotfile "$logo_file" "$HOME/.dotfiles/logos/$logo_name"
            fi
        done
    fi
    
    # --- Finalization ---
    print_success "Felis-Shell dotfiles installation complete!"
    print_info "Please restart your terminal or run 'source ~/.bashrc' to apply the changes."
    
    # --- Dependency Information ---
    echo
    print_warning "For the best experience, please ensure these dependencies are installed:"
    cat << EOF
    
  ${C_CYAN}--- Core CLI Tools ---${C_RESET}
    • ${C_GREEN}eza${C_RESET}: Modern replacement for 'ls'
    • ${C_GREEN}bat${C_RESET}: A 'cat' clone with syntax highlighting
    • ${C_GREEN}fd${C_RESET}: A simple, fast and user-friendly alternative to 'find'
    • ${C_GREEN}ripgrep (rg)${C_RESET}: A line-oriented search tool
    • ${C_GREEN}fzf${C_RESET}: A command-line fuzzy finder
    • ${C_GREEN}zoxide${C_RESET}: A smarter 'cd' command
    • ${C_GREEN}btop${C_RESET} or ${C_GREEN}htop${C_RESET}: Modern system monitors
    • ${C_GREEN}jq${C_RESET}: A lightweight and flexible command-line JSON processor
    • ${C_GREEN}unzip${C_RESET}, ${C_GREEN}unrar${C_RESET}, ${C_GREEN}p7zip${C_RESET}: For the 'extract' function
    • ${C_GREEN}bzip2${C_RESET}, ${C_GREEN}gzip${C_RESET}, ${C_GREEN}ncompress${C_RESET}, ${C_GREEN}cabextract${C_RESET}, ${C_GREEN}xz-utils${C_RESET}: Additional tools for the 'extract' function

  ${C_CYAN}--- Development ---${C_RESET}
    • ${C_GREEN}nvm${C_RESET}: Node Version Manager
    • ${C_GREEN}shellcheck${C_RESET}: Linter for shell scripts
    • ${C_GREEN}docker${C_RESET} and ${C_GREEN}docker-compose${C_RESET}: For the n8n functions and Docker aliases
    • ${C_GREEN}ngrok${C_RESET}: For the n8n-ngrok function
    • ${C_GREEN}yay${C_RESET} or ${C_GREEN}paru${C_RESET}: An AUR helper (Arch Linux specific)

  ${C_CYAN}--- Terminal & Appearance ---${C_RESET}
    • ${C_GREEN}kitty${C_RESET}: The recommended terminal emulator
    • ${C_GREEN}Nerd Fonts${C_RESET} (e.g., JetBrains Mono Nerd Font): For icons in the prompt
    • ${C_GREEN}fastfetch${C_RESET} or ${C_GREEN}neofetch${C_RESET}: For the welcome screen
    • ${C_GREEN}cowsay${C_RESET} and ${C_GREEN}fortune${C_RESET}: For the 'wisdom' alias

  ${C_YELLOW}Package Installation Commands by Distribution:${C_RESET}
  ${C_CYAN}Arch Linux:${C_RESET}
  ${C_MUTED}sudo pacman -S eza bat fd ripgrep fzf zoxide btop kitty fastfetch shellcheck jq unzip unrar p7zip cowsay fortune docker bzip2 gzip ncompress xz cabextract${C_RESET}
  ${C_MUTED}# Note: Enable and start the docker service with: sudo systemctl enable --now docker${C_RESET}
  ${C_MUTED}# Note: ngrok is not available in the official repositories. Install from AUR or the ngrok website.${C_RESET}
  
  ${C_CYAN}Ubuntu/Debian:${C_RESET}
  ${C_MUTED}sudo apt install eza bat fd-find ripgrep fzf zoxide btop kitty fastfetch shellcheck jq unzip unrar p7zip cowsay fortune docker docker-compose bzip2 gzip ncompress xz-utils cabextract${C_RESET}
  ${C_MUTED}# Note: Enable and start the docker service with: sudo systemctl enable --now docker${C_RESET}
  ${C_MUTED}# Note: ngrok is not available in the official repositories. Install from the ngrok website.${C_RESET}
  
  ${C_CYAN}Note:${C_RESET} On Ubuntu/Debian, you may need to symlink 'bat' and 'fd' commands:
  ${C_MUTED}mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat && ln -s /usr/bin/fdfind ~/.local/bin/fd${C_RESET}

EOF
}

# --- [MAIN EXECUTION] ---
# Run the installation function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dotfiles
fi
