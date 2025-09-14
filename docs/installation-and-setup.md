# Installation & Setup Guide

This guide will walk you through installing Felis Shell and show you how to customize it to make it your own.

## 🚀 Getting Started

If you want to get up and running in a flash, check out the [Quick Start Guide](quick-start.md). For more detailed instructions, read on.

1.  **Clone the Repo:**
    First, you'll need to clone the Felis Shell repo to a temporary folder.
    ```bash
    git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git /tmp/felis-shell
    cd /tmp/felis-shell
    ```

2.  **Run the Installer:**
    Next, run the `install.sh` script. This script is pretty smart:
    *   **Backs Up Your Stuff:** It saves your old dotfiles (like `~/.bashrc`) in a backup folder before it does anything.
    *   **Creates Symlinks:** It links the Felis Shell dotfiles into your home directory.
    *   **Copies Files:** It copies things like the logos to the right place.

    ```bash
    ./install.sh
    ```

3.  **Set Up Your Git Info:**
    Update the `.gitconfig` file with your name and email.
    ```bash
    cd ~/.dotfiles
    nano .gitconfig # Or whatever editor you like
    ```
    Make sure the `[user]` section has your info:
    ```ini
    [user]
        name = Your Name
        email = your.email@example.com
    ```

4.  **Reload Your Shell:**
    To see the changes, open a new terminal or run `source ~/.bashrc`.
    ```bash
    source ~/.bashrc
    ```

## 🛠️ What You'll Need

Felis Shell uses a few external tools to make it awesome. The installer will try to install these for you, but you can also install them yourself.

**Core Tools:**
- `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `btop`/`htop`, `jq`, `unzip`, `unrar`, `p7zip`, `curl`, `netcat`

**Development:**
- `nvm`, `shellcheck`, `docker`, `docker-compose`, `ngrok`, `gh`

**Appearance:**
- `kitty` (recommended terminal), `Nerd Fonts`, `fastfetch`, `cowsay`, `fortune`

## ⚙️ Making It Your Own

Felis Shell is designed to be easy to customize. All the config files are in `~/.dotfiles/.bashrc.d/`.

### 1. Your Personal Config (`user.conf`)
For your own personal settings that you don't want to commit to Git, create a `user.conf` file:
```bash
cp ~/.dotfiles/.bashrc.d/user.conf.example ~/.dotfiles/.bashrc.d/user.conf
```
You can add your own aliases, functions, and environment variables in here. This file is loaded last, so your settings will always take precedence.

### 2. Colors & Style (`00-colors.sh`)
You can change the color scheme by editing `~/.dotfiles/.bashrc.d/00-colors.sh`.

### 3. Aliases & Environment Variables (`01-aliases.sh`)
Want to add your own shortcuts? Edit `~/.dotfiles/.bashrc.d/01-aliases.sh`.
*   **Example:**
    ```bash
    alias g='git'
    export EDITOR='nvim'
    ```

### 4. The Prompt (`02-prompt.sh`)
You can customize the look of your prompt by editing `~/.dotfiles/.bashrc.d/02-prompt.sh`. The main logic is in the `build_prompt` function.

### 5. "Smart" Features (`03-hooks.sh`)
This file is where the automatic environment switching happens. You can tweak the logic for Python virtual environments or Node.js versions in here.

### 6. Custom Functions (`functions/`)
If you want to add your own shell functions, you can create a new `.sh` file in the `~/.dotfiles/.bashrc.d/functions/` directory.

## ⬆️ How to Update

To get the latest version of Felis Shell:

1.  **Go to your dotfiles folder:**
    ```bash
    cd ~/.dotfiles
    ```
2.  **Pull the latest changes:**
    ```bash
    git pull origin main
    ```
3.  **Re-run the installer (optional, but a good idea):**
    ```bash
    ./install.sh
    ```
4.  **Reload your shell:**
    ```bash
    source ~/.bashrc
