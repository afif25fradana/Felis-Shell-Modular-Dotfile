# Shell Functions Guide

Felis Shell comes with a bunch of handy functions to make your life easier. This guide gives you a quick rundown of what they are and how to use them.

## 🎯 How to Use 'Em

All these functions are ready to go as soon as you open your terminal. Just type the command and hit enter.

For a quick list of all the shortcuts and commands, just type `shortcut`. If you need more details on a specific topic, use the `help` command (like `help git` or `help dev`).

## 📁 Functions by Category

### 1. For Developers (`development.sh`)

Functions to help you get new projects up and running in no time.

#### `gitclone <repository_url> [directory]`
*   **What it does:** Clones a Git repo and jumps you right into the new folder.
*   **Example:**
    ```bash
    gitclone https://github.com/user/repo.git my-project
    ```

#### `pyinit [project_name]`
*   **What it does:** Sets up a basic Python project with a virtual environment (`.venv`), `requirements.txt`, a `.gitignore`, and a `README.md`. It also turns it into a Git repo.
*   **Example:**
    ```bash
    mkdir my-python-app && cd my-python-app
    pyinit
    ```

#### `pyinitplus [project_name]`
*   **What it does:** Like `pyinit`, but with all the bells and whistles. It adds useful tools like `black`, `flake8`, `isort`, `pytest`, and `pre-commit` to get you started with a professional setup.
*   **Example:**
    ```bash
    mkdir my-advanced-python-app && cd my-advanced-python-app
    pyinitplus
    ```

#### `nodeinit [project_name]`
*   **What it does:** Sets up a basic Node.js project. It runs `npm init -y`, installs `eslint`, `prettier`, and `nodemon`, and creates a `.gitignore`, `README.md`, and a simple `index.js`.
*   **Example:**
    ```bash
    mkdir my-node-app && cd my-node-app
    nodeinit
    ```

#### `nodeinitplus [project_name] [use_typescript]`
*   **What it does:** An upgraded `nodeinit` with optional TypeScript support. It sets up a nice project structure (`src`, `tests`) and all the config files you need.
*   **How to use:**
    *   `project_name`: (Optional) The name of your project.
    *   `use_typescript`: (Optional) Set to `true` if you want to use TypeScript.
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
*   **What it does:** Creates a simple folder structure for a web project (`src/{css,js,assets}`, `dist`) and gives you boilerplate `index.html`, `style.css`, and `main.js` files.
*   **Example:**
    ```bash
    mkdir my-website && cd my-website
    webinit
    ```

### 2. Moving Around (`directory.sh`)

Functions to make directory navigation a breeze.

#### `mkcd <directory>`
*   **What it does:** Creates a new folder and immediately `cd`s into it.
*   **Example:**
    ```bash
    mkcd my-new-folder
    ```

### 3. Managing Your Dotfiles (`dotfiles.sh`)

A simple tool to backup and restore your Felis Shell setup.

#### `dotfiles <action>`
*   **What it does:** Helps you save and load your dotfiles.
*   **Actions:**
    *   `backup`: Copies your important dotfiles to `~/.dotfiles/` and saves them in a Git repo.
    *   `restore`: Copies your saved dotfiles from `~/.dotfiles/` back to your home directory.
*   **Example:**
    ```bash
    dotfiles backup
    dotfiles restore
    ```

#### `ghissue <title> [body]`
*   **What it does:** Creates a new GitHub issue from the command line.
*   **Needs:** The GitHub CLI (`gh`) to be installed and authenticated.
*   **Example:**
    ```bash
    ghissue "Fix a critical bug" "The app crashes when clicking the main button."
    ```

#### `ghstatus`
*   **What it does:** Provides a quick overview of the current Git repository's status, including uncommitted changes, unpushed commits, and recent issues.
*   **Needs:** The GitHub CLI (`gh`).
*   **Example:**
    ```bash
    ghstatus
    ```

### 4. Working with Files (`fileops.sh`)

Some handy tools for file operations.

#### `extract <archive_file>`
*   **What it does:** Extracts pretty much any archive file you throw at it (`.tar.gz`, `.zip`, `.rar`, etc.). No need to remember a million different commands.
*   **Needs:** `tar`, `unrar`, `unzip`, and other common extraction tools.
*   **Example:**
    ```bash
    extract my_archive.tar.gz
    ```

#### `devstatus`
*   **What it does:** Shows you a quick summary of your current development environment, like your Git branch, Python venv, and running Docker containers.
*   **Example:**
    ```bash
    devstatus
    ```

#### `backup <file_or_directory>`
*   **What it does:** Makes a quick, timestamped backup of a file or folder.
*   **Example:**
    ```bash
    backup my_important_file.txt
    ```

### 5. Getting Help (`help.sh`)

Functions to help you find your way around Felis Shell.

#### `shortcut`
*   **What it does:** Shows you a big list of all the custom shortcuts and cool features you can use.
*   **Example:**
    ```bash
    shortcut
    ```

#### `help [topic]`
*   **What it does:** Gives you more detailed help on different topics.
*   **Topics:** `shortcut`, `git`, `dev`, `system`, `project`, `github`.
*   **Example:**
    ```bash
    help git
    ```

### 6. n8n Stuff (`n8n.sh`)

Functions to help you manage n8n, especially if you're using it with Docker and Ngrok.

#### `start-n8n`
*   **What it does:** Starts up your n8n services with `docker-compose`.
*   **Alias:** `n8n-start`
*   **Example:**
    ```bash
    start-n8n
    ```

#### `stop-n8n`
*   **What it does:** Stops your n8n services.
*   **Alias:** `n8n-stop`
*   **Example:**
    ```bash
    stop-n8n
    ```

#### `logs-n8n`
*   **What it does:** Shows you the live logs from your n8n containers.
*   **Alias:** `n8n-logs`
*   **Example:**
    ```bash
    logs-n8n
    ```

#### `start-n8n-ngrok`
*   **What it does:** Starts an ngrok tunnel for your local n8n, grabs the public URL, and automatically updates your `.env` file before starting n8n.
*   **Alias:** `n8n-ngrok`
*   **Needs:** `ngrok` and `jq`.
*   **Example:**
    ```bash
    start-n8n-ngrok
    ```

### 7. Network Tools (`network.sh`)

A couple of utilities for checking network stuff.

#### `myip`
*   **What it does:** Shows you your local IP address and your public IP address.
*   **Example:**
    ```bash
    myip
    ```

#### `portcheck <port> [host]`
*   **What it does:** Checks if a port is open on a specific machine (defaults to your local machine).
*   **Needs:** `nc` (netcat).
*   **Example:**
    ```bash
    portcheck 8080
    portcheck 22 example.com
    ```

### 8. Project Management (`project.sh`)

A handy tool for starting new projects.

#### `newproject <project_name> [type]`
*   **What it does:** Creates a new project folder and sets it up based on the type you choose.
*   **Types:** `python`, `node`, `web`, `shell` (default).
*   **Example:**
    ```bash
    newproject my-new-python-api python
    ```

### 9. System Maintenance (`system.sh`)

Functions to help you keep your system clean and tidy.

#### `sysclean`
*   **What it does:** Cleans up your system by clearing package caches, removing old packages, and deleting old log files. It works on most popular Linux distros.
*   **Needs:** `sudo`.
*   **Example:**
    ```bash
    sysclean
    ```

#### `serv <action> <service> [--user]`
*   **What it does:** A simpler way to manage systemd services (start, stop, restart, etc.).
*   **Needs:** `sudo` for system services.
*   **Example:**
    ```bash
    serv status nginx
    serv restart docker
