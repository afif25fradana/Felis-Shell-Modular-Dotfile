# 🚀 Modular Bash Configuration

This directory contains modular bash configuration files that are sourced by `~/.bashrc` to provide a rich, organized shell environment.

## 📚 Table of Contents

- [Key Features](#-key-features)
- [File Structure](#-file-structure)
- [Colors & Styling](#-colors--styling-00-colorssh)
- [Aliases & Environment](#️-aliases--environment-01-aliasessh)
- [Prompt](#-prompt-02-promptsh)
- [Hooks & Integrations](#-hooks--integrations-03-hookssh)
- [Functions](#️-functions-04-functionssh)
- [Quick Reference](#-quick-reference)
- [Smart Features](#-smart-features)
- [Customization](#-customization)

## ✨ Key Features

- **Modular Design:** Easy to manage and customize.
- **Smart Prompt:** Rich information at a glance.
- **Powerful Aliases and Functions:** Streamlined development workflow.
- **Automatic Environment Switching:** Seamlessly switch between Python and Node.js versions.
- **Git Integration:** Enhanced Git workflow with status caching.
- **Helpful Shortcuts:** Quick access to all custom commands.
- **Extensible Hook System:** Register functions to be called on specific events.
- **Enhanced Error Handling:** Improved error handling with `set -o pipefail`.
- **Namespaced Functions:** Internal functions are properly namespaced to prevent conflicts.
- **Comprehensive Dependencies:** Complete list of required and optional dependencies for all features.

## 📁 File Structure

- **`00-colors.sh`**: Defines the color palette and helper functions for printing colored messages.
- **`01-aliases.sh`**: Contains a collection of aliases for frequently used commands.
- **`02-prompt.sh`**: Configures the shell prompt with Git integration and other useful information.
- **`03-hooks.sh`**: Implements shell hooks for automatic environment management.
- **`functions/`**: A directory for custom shell functions, organized by category:
  - `development.sh`: Functions for project initialization and development.
  - `directory.sh`: Functions for directory operations.
  - `dotfiles.sh`: Functions for managing dotfiles.
  - `fileops.sh`: Functions for file operations.
  - `help.sh`: The help system.
  - `n8n.sh`: Functions for n8n and ngrok workflow.
  - `network.sh`: Functions for network operations.
  - `project.sh`: Functions for project management.
  - `system.sh`: Functions for system maintenance.

## 🎨 Colors & Styling (00-colors.sh)

Centralized color variables using the Sweet Theme palette with 256-color support fallbacks.

### Color Variables
```bash
C_RESET, C_BOLD, C_DIM          # Formatting
C_RED, C_GREEN, C_YELLOW        # Primary colors
C_BLUE, C_MAGENTA, C_CYAN       # Secondary colors
C_WHITE, C_GRAY, C_DARK_GRAY    # Grayscale
```

### Semantic Colors
```bash
C_SUCCESS, C_WARNING, C_ERROR   # Status colors
C_INFO, C_MUTED                 # Informational colors
```

### Helper Functions
```bash
print_success "message"   # ✓ Success message
print_warning "message"   # ⚠ Warning message
print_error "message"     # ✗ Error message
print_info "message"      # ℹ Information message
```

## ⌨️ Aliases & Environment (01-aliases.sh)

### Navigation & System
```bash
.., ..., ....    # Quick directory navigation
~                # Go to home directory
-                # Go to previous directory
ll, ls, tree     # Enhanced listing with eza (fallback to ls)
cat, catt        # Enhanced cat with bat (fallback to cat)
find             # Enhanced find with fd (fallback to find)
grep             # Enhanced grep with rg/ag (fallback to grep)
reload           # Reload the shell
h                # Show history
j                # Show jobs
df, du, free     # Enhanced system info
mkdir            # Create directory
cp, mv, rm       # Safe copy, move, and remove
lspath           # List PATH entries
fstree           # Show file system tree
biggest          # Show biggest files and directories
```

### Package Management
```bash
update           # System update (yay/paru/pacman/apt)
install          # Package installation
search           # Package search
remove           # Package removal
```

### Development Tools
```bash
# Python
py, pip, venv    # Python tools
pyserve, pytime, pyjson, pydeps, pycheck, pyver # Python utilities
vact, vdeact, vpip # Virtual environment management

# Node.js
ni, nid, nig     # npm install variants
nt, nr, ns       # npm test/run/start
nls, nout, nup   # npm listing/outdated/update
nclean, nreinstall, ncheck, nfix # Node.js project maintenance

# Web Development
serve, live, http  # Development servers

# Docker
d, dc, dps, di, drm, drmi # Docker commands
```

### Git Workflow
```bash
ga, gaa          # git add
gc, gca          # git commit
gp, gpl          # git push/pull
gs, gd, gdc      # git status/diff
gb, gco, gcb     # git branch/checkout
gm, gl, gll      # git merge/log
gst, gstp        # git stash
```

### GitHub CLI
```bash
ghpr             # Create PR in browser
ghi              # List issues
ghv              # View repository
ghc              # Clone repository
```

### System Utilities
```bash
top              # Enhanced system monitor
myip, myip6      # Show IP addresses
ports            # Show open ports
ping             # Ping with 5 packets
```

### n8n Workflow
```bash
n8n-start        # Start n8n services
n8n-stop         # Stop n8n services
n8n-logs         # View n8n container logs
n8n-ngrok        # Start n8n with ngrok tunnel
```

### Fun Stuff
```bash
wisdom           # Show a random quote
```

## 💻 Prompt (02-prompt.sh)

Smart multi-line prompt with:
- Git status caching (5-second timeout)
- Virtual environment detection
- Node.js version detection
- SSH session indicator
- Background job count
- Exit code display

### Features
- Line 1: user@host, working directory, git status, venv, Node.js version
- Line 2: exit code (if non-zero), prompt symbol
- Automatic git status caching for performance
- Visual indicators for repository state (clean/dirty/ahead)

## 🔧 Hooks & Integrations (03-hooks.sh)

### Auto-Activation
- Python virtual environments (.venv, venv, .env, env)
- Poetry environments
- Pipenv environments
- Conda environments
- Node.js version switching (.nvmrc)

### Tools Integration
- FZF (enhanced fuzzy finder)
- Zoxide (smart directory navigation)
- Bash completion enhancements

### Generic Hook System
The framework includes a powerful generic hook system that allows you to register functions to be called on specific events. This system is used internally for the `cd` command but can be extended for other events.

**API:**
```bash
# Register a function to be called on a specific event
bashrc_add_hook <event_name> <function_name>

# Execute all registered functions for a specific event
bashrc_run_hooks <event_name> [arguments...]
```

### Shell Options
```bash
histappend       # Append to history
checkwinsize     # Check window size
expand_aliases   # Expand aliases
globstar         # Enable ** globbing
cdspell          # Correct cd spelling
```

## 🛠️ Functions

### Directory Operations
```bash
mkcd "directory"        # Create and enter directory
backup "file"           # Create timestamped backup
```

### Development
```bash
newproject "name" [type]  # Create new project (python/node/web/shell)
pyinit [name]             # Initialize Python project
pyinitplus [name]         # Enhanced Python project
nodeinit [name]           # Initialize Node.js project
nodeinitplus [name]       # Enhanced Node.js project
webinit [name]            # Initialize web project
gitclone <repo> [dir]   # Clone a git repository and cd into it
devstatus                 # Show development environment status
```

### System Maintenance
```bash
sysclean              # Comprehensive system cleanup
serv "action" "service" [--user]  # Service management
```

### Network
```bash
myip                  # Show IP addresses
portcheck "port" [host]  # Check port status
```

### File Operations
```bash
extract "archive"     # Extract any archive format
backup "file"         # Enhanced backup
```

### Dotfiles Management
```bash
dotfiles <backup|restore> # Backup or restore dotfiles
```

### GitHub Workflow
```bash
ghissue "title" [body]  # Create GitHub issue
ghstatus              # Check repository status
```

## 🚀 Quick Reference

### Show All Shortcuts
```bash
shortcut              # Display all custom shortcuts
```

### Help System
```bash
help                  # Show help topics
help git              # Git workflow help
help dev              # Development help
help system           # System management help
help project          # Project management help
help github           # GitHub workflow help
```

## 🎯 Smart Features

### Automatic Environment Switching

- **Python:** Automatically activates virtual environments (`.venv`, `venv`, `.env`, `env`), Poetry, Pipenv, and Conda environments when entering a project directory.
- **Node.js:** Automatically switches Node.js versions based on the `.nvmrc` file in the project directory.

### Enhanced Workflow

- **Git Status Caching:** The prompt caches Git status for 5 seconds to improve performance.
- **Directory Navigation:** `cd` shows directory contents for small directories, and Zoxide integration provides smart directory jumping.
- **FZF Integration:** Enhanced fuzzy finding with custom keybindings.

## 🎨 Customization

- **Colors:** The color palette can be customized in `00-colors.sh`.
- **Aliases:** New aliases can be added to `01-aliases.sh`.
- **Prompt:** The prompt can be customized by modifying the `build_prompt` function in `02-prompt.sh`.
- **Functions:** New functions can be added to the `functions/` directory.
- **User Configuration:** User-specific settings can be configured in `~/.bashrc.d/user.conf` (copy `user.conf.example` to get started).