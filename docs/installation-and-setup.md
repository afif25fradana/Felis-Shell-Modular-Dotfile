# Installation and Advanced Setup

This guide provides detailed instructions for installing Felis Shell and covers advanced setup and customization options to tailor your command-line environment to your specific needs.

## 🚀 Initial Installation

For a quick start, refer to the [Quick Start Guide](quick-start.md). The following steps provide more detail on the installation process.

1.  **Clone the Repository:**
    Clone the Felis Shell repository to a temporary location to avoid path conflicts.
    ```bash
    git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git /tmp/felis-shell
    cd /tmp/felis-shell
    ```

2.  **Run the Installer Script:**
    Execute the `install.sh` script. This script performs several crucial actions:
    *   **Backup:** It safely backs up your existing dotfiles (e.g., `~/.bashrc`, `~/.gitconfig`) to a timestamped directory before creating symlinks.
    *   **Symlinking:** It creates symbolic links from your home directory to the Felis Shell dotfiles in `~/.dotfiles`.
    *   **File Copying:** It copies necessary files (like logos) to their correct locations.
    *   **Shell Reload:** It prompts you to reload your shell or open a new terminal session.

    ```bash
    ./install.sh
    ```

3.  **Configure Git:**
    Update your global Git configuration with your personal details.
    ```bash
    cd ~/.dotfiles
    nano .gitconfig # Or your preferred editor
    ```

4.  **Reload Your Shell:**
    Apply the changes by either opening a new terminal or sourcing your `.bashrc` file.
    ```bash
    source ~/.bashrc
    ```
    Ensure the `[user]` section contains your name and email:
    ```ini
    [user]
        name = Your Name
        email = your.email@example.com
    ```

4.  **Reload Your Shell:**
    To ensure all changes are applied, open a new terminal session or manually source your `.bashrc`:
    ```bash
    source ~/.bashrc
    ```

## 🛠️ Dependencies

Felis Shell leverages several external tools for its enhanced features. The `install.sh` script attempts to install these, but you can also install them manually.

### Core CLI Tools
*   `eza`: Modern `ls` replacement (for `ll` alias).
*   `bat`: `cat` clone with syntax highlighting and Git integration (for `cat` alias).
*   `fd`: Fast and user-friendly alternative to `find` (for `find` alias).
*   `ripgrep` (`rg`): Fast line-oriented search tool (for `grep` alias).
*   `fzf`: Command-line fuzzy finder (for `Ctrl+R`, `Ctrl+T`, `Alt+C` keybindings).
*   `zoxide`: Smarter `cd` command (for `z` command).
*   `btop`/`htop`: System resource monitor (for `top` alias).
*   `jq`: JSON processor.
*   `unzip`, `unrar`, `p7zip`: Archive extraction tools (for `extract` function).

### Development Tools
*   `nvm`: Node Version Manager (for Node.js auto-switching).
*   `shellcheck`: Static analysis tool for shell scripts (recommended for contributors).
*   `docker`, `docker-compose`: Containerization tools.
*   `ngrok`: Secure introspectable tunnels to localhost (for `n8n-ngrok`).

### Appearance
*   `kitty`: Recommended terminal emulator.
*   `Nerd Fonts`: Required for icon display in the prompt and `eza` listings (e.g., JetBrains Mono Nerd Font).
*   `fastfetch`: System information tool.
*   `cowsay`, `fortune`: Fun command-line utilities.

## ⚙️ Customization

Felis Shell's modular design makes customization straightforward. All configuration files are located in `~/.dotfiles/.bashrc.d/`.

### 1. User-Specific Configuration (`user.conf`)
For personal, non-version-controlled customizations, create a `user.conf` file:
```bash
cp ~/.dotfiles/.bashrc.d/user.conf.example ~/.dotfiles/.bashrc.d/user.conf
```
You can add your own aliases, functions, or environment variables here. This file is sourced last, ensuring your settings override any defaults.

### 2. Colors and Styling (`00-colors.sh`)
Modify `~/.dotfiles/.bashrc.d/00-colors.sh` to change the color palette or add new semantic colors.
*   **Variables:** `C_RED`, `C_GREEN`, `C_BOLD`, etc.
*   **Helper Functions:** `print_success`, `print_error`, `print_info`, `print_warning`.

### 3. Aliases and Environment Variables (`01-aliases.sh`)
Edit `~/.dotfiles/.bashrc.d/01-aliases.sh` to add, modify, or remove command aliases and environment variables.
*   **Example:**
    ```bash
    alias g='git'
    export EDITOR='nvim'
    ```

### 4. Prompt Configuration (`02-prompt.sh`)
Customize the appearance and information displayed in your shell prompt by editing `~/.dotfiles/.bashrc.d/02-prompt.sh`.
*   **`build_prompt` function:** This is where the prompt's logic resides.
*   **Git Status Caching:** You can adjust the `GIT_STATUS_CACHE_TIMEOUT` or disable Git status entirely if needed for performance.

### 5. Hooks and Integrations (`03-hooks.sh`)
This file manages automatic environment switching and tool integrations.
*   **Auto-activation:** Modify the logic for Python virtual environments (Poetry, Pipenv, Conda) or Node.js (`.nvmrc`).
*   **Generic Hook System:** Use `bashrc_add_hook <event_name> <function_name>` to register your own functions to be called on specific events (e.g., `cd`).

### 6. Custom Functions (`functions/`)
Add new shell functions or modify existing ones in the `~/.dotfiles/.bashrc.d/functions/` directory.
*   Create new `.sh` files for logical grouping (e.g., `my_custom_functions.sh`).
*   Ensure your functions are properly namespaced to avoid conflicts.

## ⬆️ Upgrading Felis Shell

To upgrade your Felis Shell installation to the latest version:

1.  **Navigate to your dotfiles directory:**
    ```bash
    cd ~/.dotfiles
    ```
2.  **Pull the latest changes:**
    ```bash
    git pull origin main
    ```
3.  **Re-run the installer (optional, but recommended for new dependencies):**
    ```bash
    ./install.sh
    ```
4.  **Reload your shell:**
    ```bash
    source ~/.bashrc
    ```
    This process will update your symlinked dotfiles and ensure you have the latest features and bug fixes.
