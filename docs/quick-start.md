# Quick Start Guide

Welcome to Felis Shell! This guide will get you up and running with your new modular dotfiles in under 5 minutes.

## 🚀 Installation

Felis Shell is designed for broad compatibility across Linux distributions, with a focus on Arch Linux, Ubuntu, and Debian.

1.  **Clone the Repository:**
    Open your terminal and clone the Felis Shell repository to your home directory. We recommend cloning it to `~/.dotfiles`.

    ```bash
    git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git ~/.dotfiles
    ```

2.  **Run the Installer:**
    Navigate into the newly cloned directory and execute the `install.sh` script. This script will safely back up your existing dotfiles before creating symlinks for Felis Shell.

    ```bash
    cd ~/.dotfiles
    ./install.sh
    ```

    The installer will guide you through the process, including installing recommended dependencies.

3.  **Configure Git (Optional but Recommended):**
    Update the `.gitconfig` with your personal information. This ensures your Git commits are correctly attributed.

    ```bash
    # Open .gitconfig with your preferred editor (e.g., nano, vim, or code)
    nano ~/.gitconfig
    # Or if you use VS Code:
    # code ~/.gitconfig
    ```
    Replace `Your Name` and `your.email@example.com` with your actual details:
    ```ini
    [user]
        name = Your Name
        email = your.email@example.com
    ```

4.  **Reload Your Shell:**
    To apply the changes, open a new terminal session or source your `.bashrc` file in your current session.

    ```bash
    source ~/.bashrc
    ```

    You should now see the new intelligent prompt and have access to all Felis Shell features!

## ✨ Next Steps

*   Explore the [Features](../README.md#features) to see what Felis Shell can do.
*   Dive into the [Architecture Overview](architecture.md) to understand how everything works.
*   Customize your setup by editing the files in `~/.dotfiles` (see [Installation and Advanced Setup](installation-and-setup.md)).
