# 🖥️ Terminal & Fastfetch Configuration Guide

This document provides an overview of the terminal-related configurations in your system, including fastfetch, kitty terminal, and other CLI tools.

## 📁 Directory Structure

```
~/.bashrc.d/                 # Modular bash configuration
~/.config/kitty/             # Kitty terminal configuration
~/.local/bin/                # Local binaries and scripts
~/Pictures/Logo/             # Fastfetch logo images
```

## 🚀 Fastfetch Configuration

### Random Image Fastfetch

A custom script has been created to display random images from your dotfiles logos directory as ASCII art when running fastfetch.

**Script Location:** `$HOME/.local/bin/random-fastfetch.sh`

**Usage:**
```bash
ff          # Display system info with random image logo
sysinfo     # Same as ff (alias)
```

**Features:**
- Randomly selects an image from `$HOME/.dotfiles/logos/` each time.
- If `$HOME/.dotfiles/logos` does not exist, it falls back to the `logos` directory in the script's location.
- If no images are found, it runs `fastfetch` without a custom logo.
- The logo width is set to a maximum of 55 characters, and the height is calculated automatically to maintain the aspect ratio.

**Configuration:**
The script behavior can be customized through the user configuration file `~/.bashrc.d/user.conf`:
- `FASTFETCH_ENABLED`: Enable or disable the welcome screen (default: true)
- `FASTFETCH_SCRIPT`: Path to the fastfetch script (default: $HOME/.local/bin/random-fastfetch.sh)

You can also modify the script directly to adjust:
- `LOGO_DIR`: The directory containing the logos.
- `MAX_LOGO_WIDTH`: The maximum width of the logo in characters.

## 🐱 Kitty Terminal

**Configuration File:** `~/.config/kitty/kitty.conf`

### Key Features
- **Font:** JetBrains Mono Nerd Font (14pt)
- **Theme:** Catppuccin Mocha
- **Transparency:** 90% background opacity
- **Window Management:** Hyprland-compatible settings
- **Tabs:** Bottom-aligned powerline style
- **Performance:** Optimized rendering settings

### Visual Settings
```bash
font_family      JetBrains Mono Nerd Font
background_opacity 0.90
tab_bar_edge bottom
tab_bar_style powerline
```

### Keyboard Shortcuts
- `Super+Enter` - New window
- `Super+Shift+Enter` - New tab
- `Super+W` - Close window
- `Super+1/2/3...` - Switch to tab
- `Ctrl+Shift+C/V` - Copy/Paste
- `Ctrl+Shift+Plus/Minus` - Adjust font size

##  Bash Configuration

For details on color schemes, aliases, custom functions, and other bash features, please see the main bash configuration documentation:

- **[Bash Configuration README](./README.md)**

## 📝 Customization

### Adding New Logos
1. Place image files in `$HOME/.dotfiles/logos/`
2. Supported formats: jpg, jpeg, png, gif, bmp
3. Images are automatically selected at random

### Modifying Fastfetch Script
Edit `$HOME/.local/bin/random-fastfetch.sh` to adjust:
- `LOGO_SIZE` - Character dimensions
- `LOGO_DIR` - Image directory
- Chafa options for quality

### Kitty Configuration
Edit `~/.config/kitty/kitty.conf` to modify:
- Font settings
- Colors and themes
- Keyboard shortcuts
- Window behavior
