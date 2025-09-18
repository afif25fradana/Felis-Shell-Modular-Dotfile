# Dependencies Installation Guide

Felis Shell uses various tools to provide the best command-line experience. This guide helps you install them based on your system and needs.

## Installation Priority

### Tier 1: Essential (Required for core functionality)
These tools are necessary for Felis Shell's basic features to work properly.

### Tier 2: Recommended (Enhanced experience)
Modern alternatives that significantly improve the experience but have fallbacks.

### Tier 3: Optional (Extra features)
Nice-to-have tools for specific features or visual enhancements.

---

## Arch Linux / Manjaro

### Tier 1: Essential
```bash
sudo pacman -S git bash curl wget jq unzip p7zip bzip2 gzip xz file psmisc \
               iproute2 net-tools openbsd-netcat ncurses htop
```

### Tier 2: Recommended
```bash
sudo pacman -S eza bat fd ripgrep fzf zoxide btop the_silver_searcher
```

### Tier 3: Optional
```bash
# Development tools
sudo pacman -S shellcheck shfmt docker docker-compose github-cli \
               python python-pip rust cargo

# Terminal appearance
sudo pacman -S kitty fastfetch cowsay fortune-mod ttf-jetbrains-mono-nerd
```

---

## Ubuntu / Debian / Pop!_OS

### Tier 1: Essential
```bash
sudo apt update
sudo apt install git bash curl wget jq unzip p7zip-full bzip2 gzip xz-utils \
                 file psmisc iproute2 net-tools netcat-openbsd ncurses-bin htop
```

### Tier 2: Recommended
Most of these need special installation methods on Ubuntu/Debian:

#### bat and fd (available in repos with different names)
```bash
sudo apt install bat fd-find ripgrep fzf silversearcher-ag

# Create symlinks for consistent naming
mkdir -p ~/.local/bin
[ -f /usr/bin/batcat ] && ln -sf /usr/bin/batcat ~/.local/bin/bat
[ -f /usr/bin/fdfind ] && ln -sf /usr/bin/fdfind ~/.local/bin/fd
```

#### eza (modern ls replacement)
```bash
# Method 1: Via cargo (requires rust)
cargo install eza

# Method 2: Download pre-built binary
wget -qO- https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv eza /usr/local/bin/
chmod +x /usr/local/bin/eza
```

#### zoxide (smart directory jumper)
```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

#### btop (modern system monitor)
```bash
# For Ubuntu 22.04+ / Debian 12+
sudo apt install btop

# For older versions, compile from source:
# git clone https://github.com/aristocratos/btop.git
# cd btop && make && sudo make install
```

### Tier 3: Optional
```bash
# Development tools (available in default repos)
sudo apt install shellcheck docker.io docker-compose-plugin gh \
                 python3 python3-pip rustc cargo

# Terminal appearance
sudo apt install kitty fastfetch cowsay fortune-mod

# For older Ubuntu/Debian versions, fastfetch might need manual installation:
# wget https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb
# sudo dpkg -i fastfetch-linux-amd64.deb
```

---

## Universal Installation Methods

These methods work across different distributions:

### Using Cargo (Rust Package Manager)
First install Rust if you haven't:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

Then install tools:
```bash
cargo install eza zoxide bat fd-find ripgrep
```

### Using Python pip
```bash
# Development tools
pip3 install --user pytest poetry pipenv black flake8 isort pre-commit
```

### Manual Binary Downloads
Create installation directory:
```bash
mkdir -p ~/.local/bin
```

#### shfmt (Shell formatter)
```bash
wget -O ~/.local/bin/shfmt https://github.com/mvdan/sh/releases/latest/download/shfmt_v3.7.0_linux_amd64
chmod +x ~/.local/bin/shfmt
```

#### ngrok
```bash
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xzf ngrok-v3-stable-linux-amd64.tgz -C ~/.local/bin/
rm ngrok-v3-stable-linux-amd64.tgz
```

### Node Version Manager (nvm)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
```

### Fonts
#### JetBrains Mono Nerd Font (Recommended)
```bash
# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download and install
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
rm JetBrainsMono.zip
```

---

## Dependency Checker Script

You can check which dependencies are installed with this script:

```bash
#!/bin/bash
# Save as check-deps.sh and run with: bash check-deps.sh

echo "Checking Felis Shell Dependencies..."
echo "=================================="

# Essential tools
essential_tools=("git" "bash" "curl" "jq" "unzip" "file" "htop")
# Recommended tools  
recommended_tools=("eza" "bat" "fd" "rg" "fzf" "zoxide" "btop")
# Optional tools
optional_tools=("shellcheck" "docker" "gh" "python3" "fastfetch" "cowsay")

check_tool() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "✓ $1"
        return 0
    else
        echo "✗ $1"
        return 1
    fi
}

echo -e "\n[ESSENTIAL]"
for tool in "${essential_tools[@]}"; do
    check_tool "$tool"
done

echo -e "\n[RECOMMENDED]"
for tool in "${recommended_tools[@]}"; do
    check_tool "$tool"
done

echo -e "\n[OPTIONAL]"
for tool in "${optional_tools[@]}"; do
    check_tool "$tool"
done

echo -e "\nNote: Missing tools will use fallbacks where available."
```

---

## Troubleshooting

### Permission Issues
If you encounter permission issues:
```bash
# Make sure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Package Not Found
- **Arch**: Check AUR with `yay -S package-name`
- **Ubuntu**: Check if universe/multiverse repos are enabled
- **Fedora**: Check if RPM Fusion repos are enabled

### Alternative Installation
If a package isn't available in your distro's repos:
1. Try the universal methods (cargo, pip, manual download)
2. Look for Flatpak/Snap versions
3. Compile from source as last resort

### Version Compatibility
Some tools require recent versions:
- **fzf**: v0.20.0+
- **ripgrep**: v11.0.0+
- **eza**: v0.10.0+

Check versions with: `tool-name --version`

---

## Post-Installation

After installing dependencies:

1. **Reload your shell** or open a new terminal
2. **Run the dependency checker** to verify installations
3. **Install Felis Shell** following the main installation guide
4. **Test features** to ensure everything works correctly

The Felis Shell installation script will also check for missing dependencies and provide installation suggestions.