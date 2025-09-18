# Quick Start Guide

Welcome to Felis Shell! This guide will get you set up with your new dotfiles in just a few minutes.

## 🚀 Installation

1.  **Clone the Repo:**
    Open your terminal and clone the Felis Shell repo to your home directory.

    ```bash
    git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git ~/felis-shell
    cd ~/felis-shell
    ```

2.  **Run the Installer:**
    This script will back up your old dotfiles and then set up Felis Shell.

    ```bash
    chmod +x install.sh # Make the script executable
    ./install.sh
    ```

3.  **Set Up Your Git Info (Optional but Recommended):**
    Update the `.gitconfig` file with your name and email so your commits are attributed to you.

    ```bash
    cd ~/.dotfiles
    nano .gitconfig # Add your personal info
    ```

4.  **Reload Your Shell:**
    To see the changes, open a new terminal or run `source ~/.bashrc`.

    ```bash
    source ~/.bashrc
    ```

## ✨ What's Next?

*   Check out the [Features](../README.md#features) to see all the cool stuff you can do.
*   Learn [How It All Works](architecture.md) to understand the setup.
*   Customize your new shell by editing the files in `~/.dotfiles`.
