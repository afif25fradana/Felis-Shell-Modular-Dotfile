#!/bin/bash
# scripts/install-deps.sh - Multi-distro dependency installer

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $*"; }
print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_error() { echo -e "${RED}✗${NC} $*" >&2; }

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION_ID=$VERSION_ID
else
    OS=$(uname -s)
    VERSION_ID=""
fi

install_ubuntu() {
    print_info "Updating package lists..."
    sudo apt update

    print_info "Installing essential tools..."
    sudo apt install -y git bash curl wget jq unzip p7zip-full bzip2 gzip xz-utils \
                        file psmisc iproute2 net-tools netcat-openbsd ncurses-bin htop \
                        software-properties-common gnupg

    print_info "Installing modern CLI tools..."
    # Install available via apt
    sudo apt install -y bat fd-find ripgrep fzf zoxide btop kitty shellcheck gh python3 python3-pip cowsay fortune-mod

    # Setup symlinks for bat and fd
    mkdir -p "$HOME/.local/bin"
    [ -f /usr/bin/batcat ] && ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
    [ -f /usr/bin/fdfind ] && ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"

    # Install eza (official repo)
    if ! command -v eza >/dev/null; then
        print_info "Installing eza via official repository..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
    fi

    # Install fastfetch (PPA or deb)
    if ! command -v fastfetch >/dev/null; then
        print_info "Installing fastfetch..."
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
        sudo apt update
        sudo apt install -y fastfetch
    fi
}

install_arch() {
    print_info "Installing dependencies for Arch Linux..."
    sudo pacman -S --needed --noconfirm git bash curl wget jq unzip p7zip bzip2 gzip xz file psmisc \
                                        iproute2 net-tools openbsd-netcat ncurses htop \
                                        eza bat fd ripgrep fzf zoxide btop kitty fastfetch \
                                        shellcheck gh python python-pip cowsay fortune-mod
}

case "$OS" in
    ubuntu|debian|pop|mint)
        install_ubuntu
        ;;
    arch|manjaro)
        install_arch
        ;;
    *)
        print_error "Unsupported distribution: $OS"
        exit 1
        ;;
esac

print_success "Dependencies installed successfully!"
