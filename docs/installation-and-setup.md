# Installation and Setup Guide

This guide will walk you through installing Felis Shell and show you how to customize it to make it your own.

## Getting Started

If you want to get up and running quickly, check out the Quick Start Guide. For more detailed instructions, read on.

1. Clone the Repo
First, you will need to clone the Felis Shell repository to a location of your choice. A folder in your home directory is recommended.

```bash
git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git ~/felis-shell
cd ~/felis-shell
```

2. Run the Installer
Next, run the install.sh script. This script handles several tasks:
- Backs Up Your Files: It saves your old configuration files (like .bashrc) in a backup folder before making any changes.
- Creates Links: It connects the Felis Shell files to your home directory.
- Copies Assets: It puts things like logos in the right place.

To install with all recommended tools automatically, use the following command:

```bash
./install.sh --install-deps
```

3. Set Up Your Git Info
Update the .gitconfig file with your name and email.

```bash
cd ~/.dotfiles
nano .gitconfig
```

Make sure the [user] section has your information:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

4. Reload Your Shell
To see the changes, open a new terminal or run the following command:

```bash
source ~/.bashrc
```

## What is Under the Hood

Felis Shell uses a few helper tools to provide a better experience. You do not need to worry about installing these manually because the installer can do it for you when you use the --install-deps flag.

Here is a brief look at what gets installed:

- Core Tools: These are essential for the basic features of the shell, such as git, curl, and htop for system monitoring.
- Enhanced Experience: These are modern alternatives to standard commands. For example, eza replaces ls with better colors, and bat replaces cat with syntax highlighting.
- Appearance: Tools like fastfetch and Nerd Fonts help make your terminal look great.

If you are curious about what is being installed, the installer will list each tool as it works. Most of these tools are optional, but they are recommended for the best experience.

## Making It Your Own

Felis Shell is designed to be easy to customize. All the configuration files are located in ~/.dotfiles/.bashrc.d/.

1. Your Personal Config (user.conf)
For your own personal settings that you do not want to share, create a user.conf file:

```bash
cp ~/.dotfiles/.bashrc.d/user.conf.example ~/.dotfiles/.bashrc.d/user.conf
```

You can add your own shortcuts and settings here. This file is loaded last, so your settings will always take precedence.

2. Colors and Style (00-colors.sh)
You can change the color scheme by editing ~/.dotfiles/.bashrc.d/00-colors.sh.

3. Shortcuts (01-aliases.sh)
Want to add your own command shortcuts? Edit ~/.dotfiles/.bashrc.d/01-aliases.sh.

4. The Prompt (02-prompt.sh)
You can customize the look of your command prompt by editing ~/.dotfiles/.bashrc.d/02-prompt.sh.

5. Smart Features (03-hooks.sh)
This file handles automatic environment switching, such as for Python or Node.js.

6. Custom Functions (functions/)
If you want to add your own shell functions, you can create a new file in the ~/.dotfiles/.bashrc.d/functions/ directory.

## How to Update

To get the latest version of Felis Shell:

1. Go to your original folder:
```bash
cd ~/felis-shell
```

2. Pull the latest changes:
```bash
git pull origin main
```

3. Re-run the installer (optional):
```bash
./install.sh
```

4. Reload your shell:
```bash
source ~/.bashrc
```
