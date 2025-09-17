# Terminal & Fastfetch Setup Guide

This guide gives you a quick look at how the terminal is set up, including Fastfetch, Kitty, and other tools.

## 🚀 Fastfetch Setup

### Random Image Fastfetch

There's a custom script that shows a random ASCII art logo every time you open a new terminal.

**Where it lives:** `$HOME/.local/bin/random-fastfetch.sh`

This script is installed by the `install.sh` script from the project root.

**How to use it:**
```bash
ff          # Show system info with a random logo
sysinfo     # Same as ff
```

**Features:**
- Picks a random image from `$HOME/.dotfiles/logos/`.
- If that folder doesn't exist, it'll look for a `logos` folder where the script is.
- If it can't find any images, it'll just run `fastfetch` normally.
- The logo width is capped at 55 characters, and the height adjusts automatically.

**How to tweak it:**
You can change how it works in your `~/.bashrc.d/user.conf` file:
- `FASTFETCH_ENABLED`: Set to `true` or `false` to turn the welcome screen on or off.
- `FASTFETCH_SCRIPT`: The path to the fastfetch script.

You can also edit the script directly to change:
- `LOGO_DIR`: The folder with your logos.
- `MAX_LOGO_WIDTH`: The max width of the logo.

## 🐱 Kitty Terminal

**Config file:** `~/.config/kitty/kitty.conf`

### Key Features
- **Font:** JetBrains Mono Nerd Font (14pt)
- **Theme:** Catppuccin Mocha
- **Transparency:** A nice 90% background opacity.
- **Tabs:** A cool powerline style for the tabs.

### A Few Keyboard Shortcuts
- `Super+Enter` - New window
- `Super+Shift+Enter` - New tab
- `Super+W` - Close window
- `Super+1/2/3...` - Switch to a tab
- `Ctrl+Shift+C/V` - Copy/Paste
- `Ctrl+Shift+Plus/Minus` - Change the font size

## 📝 How to Customize

### Adding New Logos
1.  Drop your image files in `$HOME/.dotfiles/logos/`.
2.  Supported formats are jpg, jpeg, png, gif, and bmp.
3.  The script will automatically pick them up.

### Modifying the Fastfetch Script
You can edit `$HOME/.local/bin/random-fastfetch.sh` to change things like the logo size and image directory.

### Kitty Configuration
Feel free to edit `~/.config/kitty/kitty.conf` to change the font, theme, shortcuts, or anything else you like.
