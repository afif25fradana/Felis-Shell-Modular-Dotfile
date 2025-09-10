# Quick Start Guide

Welcome to Felis Shell! This guide will get you up and running with your new modular dotfiles in under 5 minutes.

## 🚀 Installation

Felis Shell is designed for broad compatibility across Linux distributions, with a focus on Arch Linux, Ubuntu, and Debian.

1.  **Clone the Repository:**
    Open your terminal and clone the Felis Shell repository to a temporary location to avoid path conflicts.

    ```bash
    git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git /tmp/felis-shell
    cd /tmp/felis-shell
    ```

2.  **Run the Installer:**
    Execute the `install.sh` script. This script will safely back up your existing dotfiles before creating symlinks for Felis Shell and copying necessary files to their correct locations.

    ```bash
    chmod +x install.sh # Ensure the installer script is executable
    ./install.sh
    ```

    The installer will guide you through the process.

3.  **Configure Git (Optional but Recommended):**
    Update the `.gitconfig` with your personal information. This ensures your Git commits are correctly attributed.

    ```bash
    cd ~/.dotfiles
    nano .gitconfig # Edit with your personal information
    ```

4.  **Reload Your Shell:**
    Apply the changes by either opening a new terminal or sourcing your `.bashrc` file.

    ```bash
    source ~/.bashrc
    ```

## ✨ Next Steps

*   Explore the [Features](../README.md#features) to see what Felis Shell can do.
*   Dive into the [Architecture Overview](architecture.md) to understand how everything works.
*   Customize your setup by editing the files in `~/.dotfiles` (see [Installation and Advanced Setup](installation-and-setup.md)).
