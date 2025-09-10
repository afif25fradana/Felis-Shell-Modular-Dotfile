# Shell Functions Reference

Felis Shell provides a rich library of custom shell functions to automate common tasks, streamline development workflows, and enhance system management. This document serves as a comprehensive reference for all available functions, their purpose, and usage examples.

## 🎯 How to Use

All functions are loaded automatically when Felis Shell is initialized. You can call them directly from your terminal.

To get a quick overview of all available shortcuts and functions, type `shortcut` in your terminal. For more detailed help on specific topics, use the `help` command (e.g., `help git`, `help dev`).

## 📁 Functions by Category

### 1. Development Functions (`development.sh`)

These functions assist with project initialization and development workflows.

#### `gitclone <repository_url> [directory]`
*   **Purpose:** Clones a Git repository and optionally changes into the new directory.
*   **Example:**
    ```bash
    gitclone https://github.com/user/repo.git my-project
    ```

#### `pyinit [project_name]`
*   **Purpose:** Initializes a basic Python project. Creates a virtual environment (`.venv`), installs `pip`, sets up `requirements.txt`, a Python `.gitignore`, a `README.md`, and initializes a Git repository if one doesn't exist.
*   **Example:**
    ```bash
    mkdir my-python-app && cd my-python-app
    pyinit
    ```

#### `pyinitplus [project_name]`
*   **Purpose:** Initializes an enhanced Python project with common development tools (black, flake8, isort, pytest, pre-commit). Sets up a virtual environment, basic project structure (`src`, `tests`), and configuration files (`pyproject.toml`).
*   **Example:**
    ```bash
    mkdir my-advanced-python-app && cd my-advanced-python-app
    pyinitplus
    ```

#### `nodeinit [project_name]`
*   **Purpose:** Initializes a basic Node.js project. Runs `npm init -y`, installs common dev dependencies (eslint, prettier, nodemon), sets up a Node.js `.gitignore`, a `README.md`, and a basic `index.js` file. Initializes a Git repository if one doesn't exist.
*   **Example:**
    ```bash
    mkdir my-node-app && cd my-node-app
    nodeinit
    ```

#### `nodeinitplus [project_name] [use_typescript]`
*   **Purpose:** Initializes an enhanced Node.js project with optional TypeScript support. Installs common dev dependencies, sets up project structure (`src`, `tests`), configuration files (`.prettierrc`, `tsconfig.json` if TypeScript), and updates `package.json` scripts.
*   **Parameters:**
    *   `project_name`: (Optional) The name of the project. Defaults to the current directory name.
    *   `use_typescript`: (Optional) Set to `true` to enable TypeScript support. Defaults to `false`.
*   **Example (JavaScript):**
    ```bash
    mkdir my-advanced-node-app && cd my-advanced-node-app
    nodeinitplus
    ```
*   **Example (TypeScript):**
    ```bash
    mkdir my-ts-node-app && cd my-ts-node-app
    nodeinitplus my-ts-node-app true
    ```

#### `webinit [project_name]`
*   **Purpose:** Initializes a basic web development project with a standard structure (`src/{css,js,assets}`, `dist`). Creates `index.html`, `style.css`, `main.js`, and a `.gitignore`. Initializes a Git repository if one doesn't exist.
*   **Example:**
    ```bash
    mkdir my-website && cd my-website
    webinit
    ```

### 2. Directory Operations Functions (`directory.sh`)

These functions simplify common directory-related tasks.

#### `mkcd <directory>`
*   **Purpose:** Creates a new directory and immediately changes into it.
*   **Example:**
    ```bash
    mkcd my-new-folder
    ```

### 3. Dotfiles Management Functions (`dotfiles.sh`)

These functions help manage your Felis Shell dotfiles.

#### `dotfiles <action>`
*   **Purpose:** Manages the backup and restoration of your dotfiles.
*   **Actions:**
    *   `backup`: Copies essential dotfiles and the `.bashrc.d` directory to `~/.dotfiles/` and optionally initializes/commits to a Git repository there.
    *   `restore`: Copies dotfiles from `~/.dotfiles/` back to your home directory.
*   **Example:**
    ```bash
    dotfiles backup
    dotfiles restore
    ```

#### `ghissue <title> [body]`
*   **Purpose:** Creates a new GitHub issue using the GitHub CLI (`gh`).
*   **Dependencies:** Requires `gh` (GitHub CLI) to be installed.
*   **Example:**
    ```bash
    ghissue "Bug: Login button not working" "The login button on the homepage does not respond when clicked."
    ```

#### `ghstatus`
*   **Purpose:** Provides a quick status check of the current Git repository, including uncommitted changes, unpushed commits, and recent GitHub issues.
*   **Dependencies:** Requires `gh` (GitHub CLI) to be installed.
*   **Example:**
    ```bash
    ghstatus
    ```

### 4. File Operations Functions (`fileops.sh`)

These functions provide enhanced file manipulation capabilities.

#### `extract <archive_file>`
*   **Purpose:** Extracts various archive formats (tar.gz, zip, rar, 7z, etc.) with a single command.
*   **Dependencies:** Relies on `tar`, `bunzip2`, `unrar`, `gunzip`, `unzip`, `7z`, `unxz`, `cabextract` based on the archive type.
*   **Example:**
    ```bash
    extract my_archive.tar.gz
    ```

#### `devstatus`
*   **Purpose:** Displays a summary of the current development environment status, including Git repository info, active Python virtual environment, Node.js version, and Docker container status.
*   **Example:**
    ```bash
    devstatus
    ```

#### `backup <file_or_directory>`
*   **Purpose:** Creates a timestamped backup of a specified file or directory.
*   **Example:**
    ```bash
    backup my_important_file.txt
    backup my_project_folder
    ```

### 5. Help System Functions (`help.sh`)

These functions provide access to the Felis Shell help system.

#### `shortcut`
*   **Purpose:** Displays a comprehensive list of all custom command shortcuts, aliases, and smart features available in Felis Shell.
*   **Example:**
    ```bash
    shortcut
    ```

#### `help [topic]`
*   **Purpose:** Provides detailed help on various topics related to Felis Shell.
*   **Topics:**
    *   `shortcut`: Shows all custom shortcuts.
    *   `git`: Git command help.
    *   `dev`: Development workflow help.
    *   `system`: System management help.
    *   `project`: Project management help.
    *   `github`: GitHub workflow help.
*   **Example:**
    ```bash
    help
    help git
    ```

### 6. n8n Workflow Functions (`n8n.sh`)

These functions assist with managing n8n instances, particularly with Docker and Ngrok.

#### `start-n8n` (aliased as `n8n-start`)
*   **Purpose:** Starts n8n services using `docker-compose` in the configured n8n directory (`$N8N_DIR` or `~/n8n-docker`).
*   **Example:**
    ```bash
    n8n-start
    ```

#### `stop-n8n` (aliased as `n8n-stop`)
*   **Purpose:** Stops n8n services using `docker-compose` in the configured n8n directory.
*   **Example:**
    ```bash
    n8n-stop
    ```

#### `logs-n8n` (aliased as `n8n-logs`)
*   **Purpose:** Displays real-time logs for n8n containers using `docker-compose logs -f`.
*   **Example:**
    ```bash
    n8n-logs
    ```

#### `start-n8n-ngrok` (aliased as `n8n-ngrok`)
*   **Purpose:** Starts an ngrok tunnel for n8n (port 5678), fetches the public URL, updates the `WEBHOOK_URL` in the n8n `.env` file, and then starts n8n services.
*   **Dependencies:** Requires `ngrok` and `jq` to be installed.
*   **Example:**
    ```bash
    n8n-ngrok
    ```

### 7. Network Functions (`network.sh`)

These functions provide utilities for network information and diagnostics.

#### `myip`
*   **Purpose:** Displays your local IP addresses and attempts to fetch your public IP address.
*   **Example:**
    ```bash
    myip
    ```

#### `portcheck <port> [host]`
*   **Purpose:** Checks if a specified port is open on a given host (defaults to `localhost`).
*   **Dependencies:** Requires `nc` (netcat) to be installed.
*   **Example:**
    ```bash
    portcheck 8080
    portcheck 22 example.com
    ```

### 8. Project Management Functions (`project.sh`)

These functions help in creating new projects with predefined structures.

#### `newproject <project_name> [type]`
*   **Purpose:** Creates a new project directory and initializes it based on the specified type.
*   **Types:**
    *   `python`: Initializes an enhanced Python project using `pyinitplus`.
    *   `node`: Initializes an enhanced Node.js project using `nodeinitplus`.
    *   `web`: Initializes a web development project using `webinit`.
    *   `shell` (default): Creates a basic shell project structure with `src`, `tests`, `docs`, `README.md`, and a `.gitignore`.
*   **Example:**
    ```bash
    newproject my-new-python-api python
    newproject my-new-website web
    newproject my-new-script shell
    ```

### 9. System Maintenance Functions (`system.sh`)

These functions assist with routine system cleanup and service management.

#### `sysclean`
*   **Purpose:** Performs a comprehensive system cleanup, including clearing package manager caches (pacman, apt, dnf, yum, zypper), removing orphan packages, cleaning user caches, and trimming system logs.
*   **Dependencies:** Requires `sudo` and the relevant package manager.
*   **Example:**
    ```bash
    sysclean
    ```

#### `serv <action> <service> [--user]`
*   **Purpose:** Manages systemd services (start, stop, restart, status, enable, disable).
*   **Parameters:**
    *   `action`: The systemd action to perform (e.g., `start`, `stop`, `status`).
    *   `service`: The name of the systemd service.
    *   `--user`: (Optional) Flag to manage user-specific systemd services.
*   **Dependencies:** Requires `sudo` for system services.
*   **Example:**
    ```bash
    serv status nginx
    serv restart docker
    serv start my-app.service --user
