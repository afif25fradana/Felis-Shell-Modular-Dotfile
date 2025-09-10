# Troubleshooting Guide

This guide provides solutions to common issues you might encounter while using Felis Shell. If you don't find a solution here, please refer to the [Contributing Guidelines](contributing.md) for how to report an issue.

## ❌ Common Issues and Solutions

### 1. Installation Problems

#### Issue: `install.sh` script fails or encounters permission errors.
*   **Cause:** Incorrect permissions, missing `git` or other basic tools, or issues with `sudo`.
*   **Solution:**
    1.  Ensure you have `git` installed: `sudo apt install git` (Debian/Ubuntu) or `sudo pacman -S git` (Arch Linux).
    2.  Make sure the `install.sh` script is executable: `chmod +x ~/.dotfiles/install.sh`.
    3.  Run the installer from the correct directory: `cd ~/.dotfiles && ./install.sh`.
    4.  Ensure your user has `sudo` privileges if the script attempts to install system-wide dependencies.

#### Issue: Existing dotfiles are not backed up correctly.
*   **Cause:** The `install.sh` script might not have the necessary permissions or there's an issue with the backup process.
*   **Solution:** Manually back up your critical dotfiles before running the installer:
    ```bash
    mkdir -p ~/dotfiles_backup_manual
    cp ~/.bashrc ~/.gitconfig ~/.inputrc ~/dotfiles_backup_manual/
    # Add any other files you want to manually back up
    ```
    Then, proceed with the `install.sh`.

### 2. Prompt and Display Issues

#### Issue: The intelligent prompt doesn't display correctly (missing icons, strange characters).
*   **Cause:** Your terminal emulator or font does not support Nerd Fonts.
*   **Solution:**
    1.  **Install a Nerd Font:** Download and install a Nerd Font (e.g., JetBrains Mono Nerd Font) on your system.
    2.  **Configure Terminal Emulator:** Set your terminal emulator (e.g., Kitty, Alacritty, GNOME Terminal, VS Code Terminal) to use the installed Nerd Font.
    3.  **Reload Shell:** Open a new terminal session or run `source ~/.bashrc`.

#### Issue: The prompt is slow or Git status takes too long to update.
*   **Cause:** Large Git repositories or slow disk I/O can affect prompt performance. Felis Shell includes Git status caching to mitigate this.
*   **Solution:**
    1.  Ensure Git status caching is active. It's enabled by default in `02-prompt.sh`.
    2.  For extremely large repositories, consider disabling Git status in the prompt by commenting out relevant lines in `02-prompt.sh`.
    3.  Check your system's disk performance.

### 3. Functionality Issues

#### Issue: Aliases or functions are not working (e.g., `ll` doesn't use `eza`, `mkcd` not found).
*   **Cause:** The `.bashrc` might not be sourced, or the relevant configuration files are not loaded.
*   **Solution:**
    1.  **Reload Shell:** Always open a new terminal or run `source ~/.bashrc` after making changes to your dotfiles or after installation.
    2.  **Check Symlinks:** Verify that the symlinks in your home directory (e.g., `~/.bashrc`) point to the correct files in `~/.dotfiles`.
    3.  **Check Dependencies:** Ensure that the underlying tools for aliases (e.g., `eza`, `bat`, `fd`, `rg`) are installed. The `install.sh` script attempts to install them, but you can check manually.

#### Issue: Python virtual environments or Node.js versions are not auto-activating.
*   **Cause:** The `03-hooks.sh` script might not be correctly sourced, or the environment detection logic isn't finding your project's configuration.
*   **Solution:**
    1.  **Reload Shell:** Run `source ~/.bashrc`.
    2.  **Verify Project Files:**
        *   **Python:** Ensure your virtual environment is named `.venv`, `venv`, `.env`, or `env` in your project root. For Poetry/Pipenv, ensure `pyproject.toml` or `Pipfile` exists.
        *   **Node.js:** Ensure you have a `.nvmrc` file in your project root with the desired Node.js version.
    3.  **Check `03-hooks.sh`:** Review the script to ensure the auto-activation logic is present and not commented out.

#### Issue: `n8n-ngrok` fails to start or get a public URL.
*   **Cause:** `ngrok` or `jq` might not be installed, `ngrok` might not be running correctly, or the `.env` file is missing/incorrect.
*   **Solution:**
    1.  **Install Dependencies:** Ensure `ngrok` and `jq` are installed.
        *   `sudo pacman -S jq` (Arch Linux)
        *   `sudo apt install jq` (Debian/Ubuntu)
        *   Install `ngrok` by following its official documentation.
    2.  **Check `ngrok` Status:** After running `n8n-ngrok`, check the ngrok log file: `cat /tmp/ngrok.log`. Look for errors or connection issues.
    3.  **Verify `N8N_DIR`:** Ensure the `N8N_DIR` environment variable (if set) or the default `~/n8n-docker` path is correct and contains your `docker-compose.yml` and `.env` files.
    4.  **Firewall:** Ensure your firewall isn't blocking ngrok's access to port 4040 (for its local API) or n8n's port 5678.

### 4. General Issues

#### Issue: Commands like `update`, `install`, `sysclean` require `sudo` password repeatedly.
*   **Cause:** `sudo`'s timeout for password entry has expired.
*   **Solution:**
    1.  Run `sudo -v` before executing a series of `sudo` commands. This will refresh your `sudo` timestamp without running a command.
    2.  Consider configuring `sudoers` for specific commands if you frequently use them without a password (use with caution and understand security implications).

#### Issue: I made a change, and now my shell is broken!
*   **Cause:** A syntax error or incorrect configuration in one of your dotfiles.
*   **Solution:**
    1.  **Revert Changes:** If you know which file you modified, revert it to a previous working state (e.g., using Git if you committed your changes, or from the backup created by `install.sh`).
    2.  **Use `dotfiles restore`:** If you have a working backup in `~/.dotfiles`, use `dotfiles restore`.
    3.  **Safe Mode:** If your shell is completely unusable, try logging in via a TTY (Ctrl+Alt+F2-F6) or a different user, and then manually edit the problematic file. You can also try `bash --noprofile --norc` to start a bare shell.

## ❓ Still Having Trouble?

If you've gone through this guide and are still experiencing issues, please consider:
*   **Checking the `README.md` files** in `~/.dotfiles` and `~/.dotfiles/.bashrc.d` for additional context.
*   **Consulting the [Contributing Guidelines](contributing.md)** to learn how to report a bug effectively.
