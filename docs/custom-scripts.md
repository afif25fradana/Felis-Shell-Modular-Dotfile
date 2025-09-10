# Custom Scripts Reference

This document provides an overview of the custom scripts and tools located in your `~/.local/bin/` directory, which enhance your terminal experience.

## 📁 Directory Information

*   **Location:** `~/.local/bin/`
*   **Included in PATH:** Yes, this directory is automatically added to your system's PATH by `~/.bashrc.d/01-aliases.sh`, making scripts executable from any directory.
*   **Purpose:** This directory is intended for local user-specific scripts and executables that you want to have readily available in your command line.

## 🚀 Scripts

### `random-fastfetch.sh`

**Location:** `~/.local/bin/random-fastfetch.sh`

A custom script designed to display system information using `fastfetch` with a randomly selected ASCII art logo.

**Usage:**
```bash
ff          # Run fastfetch with a random image logo
sysinfo     # Alternative command (alias for ff)
```

**Features:**
*   **Random Logo Selection:** Randomly selects an image from `$HOME/.dotfiles/logos/` each time `ff` or `sysinfo` is executed.
*   **Fallback Mechanism:** If `$HOME/.dotfiles/logos` does not exist, it falls back to the `logos` directory in the script's own location.
*   **Graceful Degradation:** If no images are found, it runs `fastfetch` without a custom logo.
*   **Dynamic Sizing:** The logo width is set to a maximum of 55 characters, and the height is calculated automatically to maintain the aspect ratio.
*   **High-Resolution ASCII Art:** Utilizes `chafa` for high-quality ASCII art output with 256-color support.

**Configuration:**
The script's behavior can be customized through the user configuration file `~/.bashrc.d/user.conf`:
*   `FASTFETCH_ENABLED`: Set to `true` or `false` to enable or disable the welcome screen (default: `true`).
*   `FASTFETCH_SCRIPT`: Path to the fastfetch script (default: `$HOME/.local/bin/random-fastfetch.sh`).

You can also modify the `random-fastfetch.sh` script directly to adjust:
*   `LOGO_DIR`: The directory containing the logo images.
*   `MAX_LOGO_WIDTH`: The maximum width of the logo in characters.
*   `chafa` options for output quality.

## 📋 Adding New Scripts

To add your own custom script to your PATH:
1.  **Create the script file** in the `~/.local/bin/` directory.
2.  **Make it executable:**
    ```bash
    chmod +x ~/.local/bin/your-script-name.sh
    ```
3.  The script will automatically be available in your terminal after reloading your shell or opening a new session.

## ⚙️ Script Development Tips

*   **Shebang:** Always start your scripts with a proper shebang line (e.g., `#!/usr/bin/env bash` or `#!/usr/bin/python3`).
*   **Executability:** Ensure scripts are executable using `chmod +x`.
*   **Testing:** Test your scripts thoroughly before relying on them for daily use.
*   **Help Text:** Consider adding help text with `-h` or `--help` options for user-friendliness.
*   **Error Handling:** Implement robust error handling (e.g., `set -o pipefail`, `exit 1` on failure).

## 🔄 Maintenance

Scripts in this directory are considered part of your dotfiles configuration. For backup and restoration:

```bash
dotfiles backup    # Backup dotfiles including scripts in ~/.local/bin/
dotfiles restore   # Restore dotfiles including scripts in ~/.local/bin/
