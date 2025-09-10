#!/usr/bin/env bash

# Script to run fastfetch with a random image from the dotfiles logos directory

# Set the directory containing your logos
# Check for logos in ~/.dotfiles first, then fall back to script location
if [[ -d "$HOME/.dotfiles/logos" && -n "$(ls -A "$HOME/.dotfiles/logos")" ]]; then
    LOGO_DIR="$HOME/.dotfiles/logos"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    LOGO_DIR="$SCRIPT_DIR/logos"
fi

# Set the maximum width for the logo (in characters)
# Height will be calculated automatically to maintain aspect ratio
MAX_LOGO_WIDTH=55

# Check if the directory exists
if [[ ! -d "$LOGO_DIR" ]]; then
    echo "Logo directory not found: $LOGO_DIR"
    fastfetch  # Run fastfetch without custom logo
    exit 0
fi

# Find all image files in the directory
mapfile -t images < <(find "$LOGO_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) 2>/dev/null)

# Check if we found any images
if [[ ${#images[@]} -eq 0 ]]; then
    echo "No images found in $LOGO_DIR"
    fastfetch  # Run fastfetch without custom logo
    exit 0
fi

# Select a random image
RANDOM_IMAGE="${images[RANDOM % ${#images[@]}]}"

# Run fastfetch with the actual image as logo
# Set only the width, height will be calculated automatically to maintain aspect ratio
fastfetch --logo "$RANDOM_IMAGE" --logo-width "$MAX_LOGO_WIDTH" --logo-height 0 --logo-padding-top 0 --logo-padding-left 0
