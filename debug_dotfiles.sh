#!/bin/bash

# debug_dotfiles.sh - Debug script for dotfiles

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
print_info() { echo -e "${BLUE}ℹ${NC} $*"; }
print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_error() { echo -e "${RED}✗${NC} $*" >&2; }
print_debug() { echo -e "${MAGENTA}DEBUG${NC} $*" >&2; }

# Debug session function
debug_session() {
    print_info "Starting dotfiles debug session..."
    print_info "This session will help you troubleshoot issues with your dotfiles."
    
    # Check current directory
    print_info "Current directory: $(pwd)"
    
    # Check if we're in the right directory
    if [[ ! -f ".bashrc" ]]; then
        print_error "Not in the dotfiles directory (missing .bashrc)"
        print_info "Please navigate to your dotfiles directory and run this script again."
        return 1
    fi
    
    print_success "In the correct dotfiles directory"
    
    # Check bash version
    print_info "Bash version: ${BASH_VERSION}"
    if ((BASH_VERSINFO[0] < 4)); then
        print_warning "Bash version 4.0+ recommended"
    else
        print_success "Bash version is sufficient"
    fi
    
    # Check directory structure
    print_info "Checking directory structure..."
    local dirs=(".bashrc.d" ".bashrc.d/functions" ".local/bin")
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            print_success "Found directory: $dir ($(find "$dir" -type f | wc -l) files)"
        else
            print_warning "Missing directory: $dir"
        fi
    done
    
    # Check essential files
    print_info "Checking essential files..."
    local files=(".bashrc" ".gitconfig" ".inputrc" ".editorconfig" "install.sh" "test_dotfiles.sh")
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            print_success "Found file: $file"
        else
            print_warning "Missing file: $file"
        fi
    done
    
    # Check .bashrc.d files
    if [[ -d ".bashrc.d" ]]; then
        print_info "Checking .bashrc.d files..."
        local modules=("00-colors.sh" "01-aliases.sh" "02-prompt.sh" "03-hooks.sh")
        for module in "${modules[@]}"; do
            if [[ -f ".bashrc.d/$module" ]]; then
                print_success "Found module: $module"
            else
                print_warning "Missing module: $module"
            fi
        done
    fi
    
    # Check sourcing
    print_info "Testing .bashrc sourcing..."
    if bash -c "source .bashrc 2>/dev/null && echo 'SUCCESS'" >/dev/null; then
        print_success "Successfully sourced .bashrc"
    else
        print_error "Failed to source .bashrc"
        print_info "Trying to identify the issue..."
        # Try to source with error output
        if bash -c "source .bashrc" 2>/tmp/bashrc_error; then
            print_success "Actually sourced .bashrc successfully"
        else
            print_error "Error when sourcing .bashrc:"
            cat /tmp/bashrc_error
            rm -f /tmp/bashrc_error
        fi
    fi
    
    # Check PATH
    print_info "Current PATH:"
    echo "$PATH" | tr ':' '
' | sed 's/^/  /'
    
    # Check if .local/bin is in PATH
    if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || [[ ":$PATH:" == *":.local/bin:"* ]]; then
        print_success ".local/bin is in PATH"
    else
        print_warning ".local/bin is not in PATH"
    fi
    
    # Check custom functions
    print_info "Testing custom functions..."
    if bash -i -c "source .bashrc && type extract >/dev/null 2>&1" 2>/dev/null; then
        print_success "Extract function is available"
    else
        print_warning "Extract function is not available"
    fi
    
    # Check aliases
    print_info "Testing aliases..."
    if bash -i -c "source .bashrc && alias ll >/dev/null 2>&1" 2>/dev/null; then
        print_success "ll alias is available"
    else
        print_warning "ll alias is not available"
    fi
    
    # Interactive debug session
    print_info "Entering interactive debug session..."
    print_info "You can now test commands. Type 'exit' to quit."
    print_info "Try sourcing .bashrc and testing functions:"
    print_info "  source .bashrc"
    print_info "  extract file.zip"
    print_info "  ll"
    print_info "  echo \$USE_NERD_FONT"
    
    # Start interactive session
    bash
}

# Show help
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Debug script for dotfiles.

OPTIONS:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output

EXAMPLES:
    $0              Run debug session
    $0 -v           Run debug session with verbose output

EOF
}

# Parse command line arguments
VERBOSE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run debug session
debug_session