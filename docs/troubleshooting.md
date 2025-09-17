# Troubleshooting Guide

Ran into a snag? No worries, it happens! This guide has some tips for common issues. If you don't find what you're looking for here, feel free to open an issue on GitHub.

## ❌ Common Issues & Fixes

### 1. Installation Problems

#### My `install.sh` script isn't working.
*   **What might be happening:** You might be missing `git`, the script might not be executable, or there could be a `sudo` issue.
*   **What to try:**
    1.  Make sure you have `git` installed.
    2.  Make the `install.sh` script executable: `chmod +x install.sh`.
    3.  Run the installer from the right folder: `cd /tmp/felis-shell && ./install.sh`.

#### My old dotfiles didn't get backed up.
*   **What might be happening:** The script might not have had the right permissions.
*   **What to try:** You can always back up your files manually before running the installer, just in case.
    ```bash
    mkdir -p ~/dotfiles_backup_manual
    cp ~/.bashrc ~/.gitconfig ~/.inputrc ~/dotfiles_backup_manual/
    ```

### 2. Prompt & Display Issues

#### My prompt looks weird (missing icons, strange characters).
*   **What might be happening:** You probably need a Nerd Font.
*   **What to try:**
    1.  **Install a Nerd Font:** JetBrains Mono Nerd Font is a good one.
    2.  **Set it in your terminal:** Open your terminal's settings and change the font to the Nerd Font you just installed.

#### My prompt is slow.
*   **What might be happening:** This can happen in really big Git repos.
*   **What to try:**
    1.  Felis Shell has Git status caching to help with this, which is on by default.
    2.  If it's still slow, you can turn off the Git status in the prompt by editing `02-prompt.sh`.

### 3. Things Aren't Working

#### My aliases or functions aren't working.
*   **What might be happening:** Your shell might not have loaded the new configs, or you might be missing a tool.
*   **What to try:**
    1.  **Reload your shell:** Open a new terminal or run `source ~/.bashrc`.
    2.  **Check your symlinks:** Make sure `~/.bashrc` is pointing to the right file in `~/.dotfiles`.
    3.  **Check your tools:** Make sure you have `eza`, `bat`, `fd`, and `rg` installed.

#### The `dotfiles` command isn't working.
*   **What might be happening:** The `~/.dotfiles` directory might not exist, or you might not have the correct permissions.
*   **What to try:**
    1.  **Make sure the `~/.dotfiles` directory exists:** If it doesn't, you can create it with `mkdir ~/.dotfiles`.
    2.  **Check your permissions:** Make sure you have read and write permissions for the `~/.dotfiles` directory.

#### The `newproject` command isn't working.
*   **What might be happening:** You might be missing the required tools for the project type you are trying to create.
*   **What to try:**
    1.  **Check the output of the command:** The `newproject` command should give you an error message that tells you what is missing.
    2.  **Install the required tools:** For example, if you are trying to create a Python project, you will need to have `python` and `pip` installed.

#### My Python venv or Node.js version isn't switching automatically.
*   **What might be happening:** The auto-switching script might not be loaded, or it can't find your project's config files.
*   **What to try:**
    1.  **Reload your shell:** `source ~/.bashrc`.
    2.  **Check your project files:**
        *   **Python:** Make sure your virtual environment folder is named `.venv`, `venv`, `.env`, or `env`.
        *   **Node.js:** Make sure you have a `.nvmrc` file in your project folder.

#### `start-n8n-ngrok` isn't working.
*   **What might be happening:** You might be missing `ngrok` or `jq`, or there could be a problem with your `.env` file.
*   **What to try:**
    1.  **Install `ngrok` and `jq`**.
    2.  **Check the `ngrok` log:** `cat /tmp/ngrok.log`.
    3.  **Check your `N8N_DIR`:** Make sure it's pointing to the right folder.

### 4. General Stuff

#### I have to type my `sudo` password all the time.
*   **What might be happening:** Your `sudo` session is timing out.
*   **What to try:** Run `sudo -v` before you run a bunch of `sudo` commands to refresh the session.

#### I broke my shell!
*   **What might be happening:** You probably made a typo in one of the config files.
*   **What to try:**
    1.  **Undo your changes:** If you know what you changed, just undo it.
    2.  **Use the backup:** The `install.sh` script made a backup of your old dotfiles. You can restore from that.
    3.  **Safe Mode:** If you can't even open a terminal, try `bash --noprofile --norc` to start a bare-bones shell so you can fix the broken file.

## ❓ Still Stuck?

If you're still having trouble, feel free to open an issue on GitHub.
