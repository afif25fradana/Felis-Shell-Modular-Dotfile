# The Felis Cheat Sheet

This is a quick reference for the most useful commands and shortcuts in your shell.

## Navigation

| Command | What it does |
| :--- | :--- |
| `..` / `...` | Go up one or two levels |
| `~` | Go to your home folder |
| `-` | Go back to the previous folder |
| `mkcd <dir>` | Create a new folder and enter it immediately |
| `ll` / `ls` | List files with icons and git status |
| `tree` | Show the directory structure as a tree |

## Development and Projects

| Command | What it does |
| :--- | :--- |
| `newproject <name> [type]` | Start a new project (python, node, web, shell) |
| `pyinit` / `pyinitplus` | Start a new basic or advanced Python project |
| `nodeinit` / `nodeinitplus` | Start a new basic or advanced Node.js project |
| `webinit` | Start a new web project structure |
| `gitclone <url>` | Clone a repository and jump into it |
| `devstatus` | Summary of your current development environment |
| `vact` / `vdeact` | Activate or deactivate a Python virtual environment |
| `ni` / `ns` / `nt` | Shortcuts for npm install, start, and test |

## Git

| Command | What it does |
| :--- | :--- |
| `gs` | Short and clean git status |
| `ga` / `gaa` | Add specific files or all changes to git |
| `gc <message>` | Commit changes with a message |
| `gp` / `gpl` | Push or pull changes from the remote repository |
| `gl` / `gll` | Visual git log (formatted or all branches) |
| `gco` / `gcb` | Checkout a branch or create and checkout a new one |

## GitHub

| Command | What it does |
| :--- | :--- |
| `ghissue <title> <body>` | Create a new GitHub issue from the terminal |
| `ghstatus` | Overview of the repository status and issues |
| `ghpr` | Create a pull request via the web interface |
| `ghv` | View the repository on GitHub in your browser |

## File Operations

| Command | What it does |
| :--- | :--- |
| `extract <file>` | Extract any archive (.zip, .tar.gz, .rar, etc.) |
| `backup <file>` | Create a quick, timestamped backup of a file |
| `cat` | View file content with syntax highlighting |
| `find <pattern>` | Find files quickly using a pattern |
| `grep <pattern>` | Search for text within files |

## System and Network

| Command | What it does |
| :--- | :--- |
| `sysclean` | Clean system caches, logs, and old packages |
| `serv <action> <service>` | Manage systemd services (start, stop, status) |
| `update` / `install` | Update the system or install new packages |
| `top` | Monitor system resources and processes |
| `myip` | Show your local and public IP addresses |
| `portcheck <port>` | Check if a specific port is open |

## n8n Utilities

| Command | What it does |
| :--- | :--- |
| `start-n8n` / `stop-n8n` | Start or stop your n8n services |
| `logs-n8n` | View live logs from your n8n containers |
| `start-n8n-ngrok` | Start n8n with an automated ngrok tunnel |

## Help and Utilities

| Command | What it does |
| :--- | :--- |
| `shortcut` | Show a list of all shortcuts and features |
| `help [topic]` | Get detailed help for a specific topic |
| `reload` | Reload your shell configuration immediately |
| `bashrc` / `aliases` | Quickly edit your shell or alias configuration |
| `dotfiles <action>` | Backup or restore your Felis Shell configuration |
