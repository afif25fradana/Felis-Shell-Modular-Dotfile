# <img src="logos/FullBody Logo.png" alt="Felis Shell Logo" width="50"/> Felis Shell - My Personal Dotfiles

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-bash-green.svg)
![OS](https://img.shields.io/badge/os-Linux-blueviolet.svg)

Welcome to **Felis Shell**, my personal collection of dotfiles for creating a comfy and powerful command-line setup. I originally built this for Arch Linux, but it should work just fine on other distros like Ubuntu and Debian.

## Why I Made This

Honestly, I'm lazy. I got tired of forgetting command-line shortcuts and complex commands for different tools. Felis Shell is my attempt to automate all that stuff away so I can have an easier and more enjoyable time in the terminal. If you're also tired of memorizing everything, maybe you'll find it useful too!

## Quick Start

Ready to transform your command line experience? Here's how to get started:

1. **Clone and Install:**
    ```bash
    git clone https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile.git ~/felis-shell
    cd ~/felis-shell
    chmod +x install.sh
    ./install.sh
    ```

2. **Set Up Your Git Info:**
    ```bash
    cd ~/felis-shell
    nano .gitconfig  # Add your name and email
    ```

3. **Reload Your Shell:**
    ```bash
    source ~/.bashrc
    ```

Want to see what the installer will do first? Run `./install.sh --dry-run`

## Features

Felis Shell transforms your terminal with powerful features designed for developers and power users:

- **Smart Prompt** - Beautiful two-line prompt showing Git status, Python/Node versions, and more
- **Modern Commands** - Uses tools like `eza`, `bat`, `ripgrep` with automatic fallbacks
- **Auto Environment** - Automatically activates Python venvs and switches Node versions
- **Developer Tools** - Shortcuts and functions for Git, Docker, Python, Node.js workflows  
- **Project Templates** - Quick setup commands for Python, Node.js, and web projects
- **Safe Installation** - Backs up your existing dotfiles before making changes
- **Comprehensive Testing** - Built-in tools to validate and debug your configuration

<details>
<summary><strong>See all features</strong></summary>

- **Modular Design:** Configs split into logical, manageable files
- **Performance Optimized:** Git status caching and lazy loading for speed
- **150+ Functions:** Everything from `mkcd` to `extract` to `sysclean`
- **Network Tools:** IP checking, port scanning, tunnel management
- **File Operations:** Universal archive extraction, smart backups
- **System Management:** Service control, cleanup utilities
- **Integration Ready:** Works with Docker, n8n, ngrok, and more
- **Extensive Documentation:** Detailed guides for every aspect
- **Cross-Distro:** Tested on Arch, Ubuntu, Debian, Fedora

</details>

## What's Included

```
Felis Shell/
├── Smart shell prompt with Git integration
├── 150+ custom functions and aliases  
├── Automatic environment management
├── Modern CLI tools integration
├── Developer workflow shortcuts
├── System maintenance utilities
├── Testing and debugging tools
└── Comprehensive documentation
```

## Documentation

| Guide | Description |
|-------|-------------|
| **[Quick Start](docs/quick-start.md)** | Get up and running in 5 minutes |
| **[Dependencies](docs/dependencies-installation-guide.md)** | Complete installation guide for all tools |
| **[Architecture](docs/architecture.md)** | How everything fits together |
| **[Shell Functions](docs/shell-functions-reference.md)** | Guide to all 150+ functions |
| **[Installation & Setup](docs/installation-and-setup.md)** | Detailed setup and customization |
| **[Testing & Debugging](docs/testing-debugging.md)** | Tools for validating your setup |
| **[Troubleshooting](docs/troubleshooting.md)** | Solutions for common issues |
| **[Terminal Setup](docs/terminal-and-fastfetch.md)** | Configure Kitty, Fastfetch, and more |
| **[Custom Scripts](docs/custom-scripts.md)** | Info on scripts in ~/.local/bin |
| **[Contributing](docs/contributing.md)** | How to contribute to the project |

## System Requirements

Felis Shell works on most Linux distributions with bash 4.0+:

- **Fully Tested:** Arch Linux, Ubuntu 20.04+, Debian 11+
- **Should Work:** Fedora, CentOS, Pop!_OS, Linux Mint
- **Minimum:** bash, git, curl, basic CLI tools
- **Recommended:** See the [Dependencies Guide](docs/dependencies-installation.md)

## Example Workflow

Here's what a typical development session looks like with Felis Shell:

```bash
# Smart directory navigation
z my-project          # Jump to project with zoxide

# Automatic environment activation (Python venv detected and activated)
# Prompt shows: ┌──(user@host)─[~/dev/my-project]─(git:main ✓)─(py:venv)

# Quick project setup
newproject api-service python    # Create new Python project
pyinitplus                       # Set up with linting, testing, pre-commit

# Development shortcuts  
g status              # Git status
g add .              # Git add all
g cm "feat: add new endpoint"    # Git commit with message
g push               # Git push

# System maintenance
sysclean             # Clean package cache, logs, etc.
devstatus           # Show current dev environment status
```

## Testing & Debugging

Felis Shell includes comprehensive testing tools:

```bash
# Run all tests
./test_dotfiles.sh

# Debug configuration issues  
./debug_dotfiles.sh

# Test installation without changes
./install.sh --dry-run
```

## Project Structure

```
Felis-Shell-Modular-Dotfile/
├── install.sh                    # Main installation script
├── test_dotfiles.sh              # Test suite
├── debug_dotfiles.sh             # Debug utilities
├── .bashrc                       # Main bashrc file
├── .bashrc.d/                    # Modular configuration
│   ├── 00-colors.sh             # Color definitions
│   ├── 01-aliases.sh            # Command aliases
│   ├── 02-prompt.sh             # Shell prompt
│   ├── 03-hooks.sh              # Auto environment switching
│   └── functions/               # Custom shell functions
├── .config/                     # Application configs
│   └── kitty/                   # Terminal configuration
├── logos/                       # ASCII art for fastfetch
├── scripts/                     # Utility scripts
└── docs/                        # Comprehensive documentation
```

## Support & Contributing

- **Issues:** Found a bug? [Open an issue](https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile/issues)
- **Questions:** Check the [Troubleshooting Guide](docs/troubleshooting.md)
- **Contributing:** See the [Contributing Guide](docs/contributing.md)
- **Documentation:** All guides are in the `docs/` folder

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
<em>Transform your terminal experience with Felis Shell</em><br>
<em>Because life's too short for memorizing commands</em>
</p>