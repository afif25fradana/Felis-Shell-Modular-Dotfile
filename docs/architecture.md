# Architecture: The Tinkerer's Guide

This guide is for anyone who wants to understand how Felis Shell is put together so they can change, add, or remove things. The goal of this project is to be modular—meaning every part is in its own box, making it hard to break the whole system when you are just playing with one piece.

## Where do I find X?

If you want to change something, you just need to know which file it lives in. Everything is organized inside the `.bashrc.d` directory.

### I want to change my command shortcuts (aliases)
Look in `01-aliases.sh`. This is where all the short commands like `ll` or `gs` are defined. If you want to add a new shortcut for a command you use all the time, add it here.

### I want to change how my prompt looks
Look in `02-prompt.sh`. This file controls what you see next to your cursor. It handles the colors, the Git branch display, and the multi-line layout. If you want to change the colors or add new information to the prompt, this is the place.

### I want to change terminal colors
Look in `00-colors.sh`. This file defines the color palette used by the rest of the scripts. It creates variables like `C_PRIMARY` or `C_SUCCESS` so that the same colors are used everywhere.

### I want to add or change "automatic" behaviors
Look in `03-hooks.sh`. This file contains "hooks" that run every time you do something, like changing directories (`cd`). This is what automatically activates Python virtual environments or shows you project info when you enter a folder.

### I want to add a new custom function
Look in the `functions/` directory. Instead of one giant file, functions are grouped by what they do:
- **System tasks?** Put them in `functions/system.sh`.
- **Network tools?** Put them in `functions/network.sh`.
- **New project helpers?** Put them in `functions/development.sh`.

## How everything loads

When you start your terminal, your main `~/.bashrc` runs. Its only job is to go into the `.bashrc.d` folder and load every file it finds there in order.

1. **Colors first** (`00-colors.sh`): So that other scripts can use color.
2. **Aliases second** (`01-aliases.sh`): So your shortcuts are ready.
3. **Prompt third** (`02-prompt.sh`): So your screen looks right.
4. **Hooks fourth** (`03-hooks.sh`): So the automation starts working.
5. **Functions last** (`functions/*.sh`): So all your tools are in your pocket.

## Making your own changes

The best way to tinker is to:
1. Find the file that handles what you want to change.
2. Make your edit.
3. Save the file.
4. Run `source ~/.bashrc` in your terminal to see the changes immediately.

If you make a mistake and your terminal starts acting weird, you can usually just undo your change and "source" the file again.
