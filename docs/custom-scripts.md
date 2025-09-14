# Custom Scripts Guide

This is a quick guide to the custom scripts that live in your `~/.local/bin/` folder.

## 📁 Where They Live

*   **Location:** `~/.local/bin/`
*   **In Your PATH?:** Yep! This folder is automatically added to your system's PATH, so you can run these scripts from anywhere.
*   **What it's for:** This is the perfect place to put your own custom scripts and tools that you want to be able to run easily from the command line.

## 🚀 The Scripts

### `random-fastfetch.sh`

**Location:** `~/.local/bin/random-fastfetch.sh`

This is a fun little script that runs `fastfetch` to show your system info, but with a random ASCII art logo each time.

**How to use it:**
```bash
ff          # Run fastfetch with a random logo
sysinfo     # Another way to run it (it's an alias)
```

**Features:**
*   **Random Logos:** Picks a random image from `$HOME/.dotfiles/logos/` every time you run it.
*   **Fallback:** If it can't find that folder, it'll look for a `logos` folder where the script is located.
*   **No Logo? No Problem:** If it can't find any images, it'll just run `fastfetch` normally.
*   **Smart Sizing:** The logo is set to a max width of 55 characters, and the height adjusts automatically to keep the aspect ratio.

**How to tweak it:**
You can change how the script works in your `~/.bashrc.d/user.conf` file:
*   `FASTFETCH_ENABLED`: Set to `true` or `false` to turn the welcome screen on or off.
*   `FASTFETCH_SCRIPT`: The path to the fastfetch script.

You can also edit the `random-fastfetch.sh` script directly to change:
*   `LOGO_DIR`: The folder where your logos are.
*   `MAX_LOGO_WIDTH`: The max width of the logo.

## 📋 How to Add Your Own Scripts

1.  **Create a new script** in the `~/.local/bin/` folder.
2.  **Make it executable:**
    ```bash
    chmod +x ~/.local/bin/your-cool-script.sh
    ```
3.  That's it! Your new script will be available in your terminal after you open a new one or reload your shell.

## ⚙️ A Few Tips for Writing Scripts

*   **Shebang:** Always start your scripts with `#!/usr/bin/env bash`.
*   **Make it Executable:** Don't forget to `chmod +x` your script.
*   **Test it Out:** It's always a good idea to test your scripts before you rely on them.
*   **Help Text:** Adding a `-h` or `--help` option is a nice touch.
*   **Error Handling:** Using `set -o pipefail` and `exit 1` on errors is a good practice.

## 🔄 Backing Up Your Scripts

Your custom scripts are backed up along with the rest of your dotfiles when you run the `dotfiles` command:

```bash
dotfiles backup    # Backs up your scripts in ~/.local/bin/
dotfiles restore   # Restores your scripts
