#!/usr/bin/env bash

# Script to run fastfetch with a random image from the dotfiles logos directory

# Exit on error, undefined vars, and pipe failures
set -euo pipefail

# Check for fastfetch installation
if ! command -v fastfetch >/dev/null 2>&1; then
    echo "Error: fastfetch is not installed. Please install it first." >&2
    exit 1
fi

# Set default configuration
MAX_LOGO_WIDTH=${FELIS_LOGO_WIDTH:-55}
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/felis-shell"
CACHE_FILE="$CACHE_DIR/last_logo"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Set the directory containing your logos
# Check for logos in ~/.dotfiles first, then fall back to script location
if [[ -d "$HOME/.dotfiles/logos" && -n "$(ls -A "$HOME/.dotfiles/logos" 2>/dev/null)" ]]; then
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

# Function to validate image file
validate_image() {
    local file=$1
    local mime
    
    # Check if file exists and is readable
    if [[ ! -f "$file" || ! -r "$file" ]]; then
        return 1
    fi
    
    # Check if file is an image (requires file command)
    if command -v file >/dev/null 2>&1; then
        mime=$(file -b --mime-type "$file")
        if [[ ! $mime =~ ^image/ ]]; then
            return 1
        fi
    fi
    
    return 0
}

# Find all image files in the directory
while IFS= read -r -d '' file; do
    if validate_image "$file"; then
        images+=("$file")
    fi
done < <(find "$LOGO_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -print0 2>/dev/null)

# Check if we found any images
if [[ ${#images[@]} -eq 0 ]]; then
    echo "No valid images found in $LOGO_DIR"
    echo "Running fastfetch without custom logo..."
    fastfetch
    exit 0
fi

# Select a random image, avoiding the last used one if possible
RANDOM_IMAGE="${images[RANDOM % ${#images[@]}]}"
if [[ ${#images[@]} -gt 1 && -f "$CACHE_FILE" ]]; then
    last_image=$(cat "$CACHE_FILE" 2>/dev/null)
    while [[ "$RANDOM_IMAGE" == "$last_image" && ${#images[@]} -gt 1 ]]; do
        RANDOM_IMAGE="${images[RANDOM % ${#images[@]}]}"
    done
fi

# Save the current image to cache
echo "$RANDOM_IMAGE" > "$CACHE_FILE"

# Run fastfetch with error handling
if ! fastfetch --logo "$RANDOM_IMAGE" --logo-width "$MAX_LOGO_WIDTH" --logo-height 0 --logo-padding-top 0 --logo-padding-left 0; then
    echo "Error: Failed to run fastfetch with custom logo"
    echo "Running without logo as fallback..."
    fastfetch
fi
