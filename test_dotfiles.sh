#!/bin/bash

# test_dotfiles.sh - Test script for dotfiles safety and functionality

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() { echo -e "${BLUE}ℹ${NC} $*"; }
print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_error() { echo -e "${RED}✗${NC} $*" >&2; }

# Function to find all relevant files
find_dotfiles() {
    local files=()
    
    # Add root-level files
    for file in .bashrc .gitconfig .inputrc .editorconfig; do
        if [[ -f "$file" ]]; then
            files+=("$file")
        fi
    done
    
    # Add .bashrc.d files
    if [[ -d ".bashrc.d" ]]; then
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find .bashrc.d -name "*.sh" -type f -print0)
    fi
    
    # Add function files
    if [[ -d ".bashrc.d/functions" ]]; then
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find .bashrc.d/functions -name "*.sh" -type f -print0)
    fi
    
    # Add .local/bin scripts
    if [[ -d ".local/bin" ]]; then
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find .local/bin -type f -print0)
    fi
    
    # Add root-level scripts
    if [[ -f "random-fastfetch.sh" ]]; then
        files+=("random-fastfetch.sh")
    fi
    
    echo "${files[@]}"
}

echo "=== Dotfiles Test Script ==="

# Test 1: Check that all files have proper shebangs
echo "Test 1: Checking shebang lines..."
missing_shebangs=0
while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        if ! head -n 1 "$file" | grep -q "^#!/bin/bash" && ! head -n 1 "$file" | grep -q "^#!/usr/bin/env bash"; then
            print_error "Missing shebang in $file"
            ((missing_shebangs++))
        else
            print_success "Shebang present in $file"
        fi
    fi
done < <(find_dotfiles)

if [[ $missing_shebangs -eq 0 ]]; then
    print_success "All files have proper shebangs"
else
    print_error "$missing_shebangs files missing shebangs"
    exit 1
fi

# Test 2: Check that all files have valid syntax
echo "Test 2: Checking all files for syntax errors..."
syntax_errors=0
while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        if bash -n "$file"; then
            print_success "Syntax valid in $file"
        else
            print_error "Syntax errors in $file"
            ((syntax_errors++))
        fi
    fi
done < <(find_dotfiles)

if [[ $syntax_errors -eq 0 ]]; then
    print_success "All files have valid syntax"
else
    print_error "$syntax_errors files have syntax errors"
    exit 1
fi

# Test 3: Run shellcheck on all files (if available)
if command -v shellcheck >/dev/null; then
    echo "Test 3: Running shellcheck analysis (informational only)..."
    shellcheck_issues=0
    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            # Skip user.conf.example as it's not meant to be executed
            if [[ "$file" == *.conf.example ]]; then
                print_info "Skipping shellcheck for $file (configuration example)"
                continue
            fi
            
            # Run shellcheck and capture output
            if shellcheck "$file" >/dev/null 2>&1; then
                print_success "Shellcheck passed for $file"
            else
                print_warning "Shellcheck found issues in $file (issues will be shown)"
                shellcheck "$file"
                ((shellcheck_issues++))
            fi
        fi
    done < <(find_dotfiles)

    if [[ $shellcheck_issues -eq 0 ]]; then
        print_success "Shellcheck analysis complete - no issues found"
    else
        print_warning "Shellcheck analysis complete - $shellcheck_issues files had issues (see above)"
    fi
else
    echo "Test 3: Skipping shellcheck (not installed)"
fi

# Test 4: Check for common issues in specific files
echo "Test 4: Checking for common issues..."
common_issues=0

# Check .bashrc for proper sourcing
if [[ -f ".bashrc" ]]; then
    if grep -q "BASHRC_DIR.*\.bashrc\.d" ".bashrc"; then
        print_success "Found sourcing of .bashrc.d in .bashrc"
    else
        print_error "Missing sourcing of .bashrc.d in .bashrc"
        ((common_issues++))
    fi
fi

# Check aliases file for essential aliases
if [[ -f ".bashrc.d/01-aliases.sh" ]]; then
    essential_aliases=("ll" "ls" "cat" "find" "grep")
    for alias in "${essential_aliases[@]}"; do
        if grep -q "alias $alias=" ".bashrc.d/01-aliases.sh"; then
            print_success "Found alias $alias in 01-aliases.sh"
        else
            print_error "Missing alias $alias in 01-aliases.sh"
            ((common_issues++))
        fi
    done
fi

# Check prompt file for build_prompt function
if [[ -f ".bashrc.d/02-prompt.sh" ]]; then
    if grep -q "build_prompt" ".bashrc.d/02-prompt.sh"; then
        print_success "Found build_prompt function in 02-prompt.sh"
    else
        print_error "Missing build_prompt function in 02-prompt.sh"
        ((common_issues++))
    fi
fi

# Check hooks file for cd function
if [[ -f ".bashrc.d/03-hooks.sh" ]]; then
    if grep -q "^cd()" ".bashrc.d/03-hooks.sh"; then
        print_success "Found cd function in 03-hooks.sh"
    else
        print_error "Missing cd function in 03-hooks.sh"
        ((common_issues++))
    fi
fi

if [[ $common_issues -eq 0 ]]; then
    print_success "No common issues found"
else
    print_error "$common_issues common issues found"
    exit 1
fi

# Test 5: Verify installation script
echo "Test 5: Verifying installation script..."
if [[ -f "install.sh" ]]; then
    if bash -n "install.sh"; then
        print_success "Installation script syntax is valid"
    else
        print_error "Installation script has syntax errors"
        exit 1
    fi
    
    # Check if install script has help option
    if ./install.sh --help >/dev/null 2>&1; then
        print_success "Installation script has help option"
    else
        print_warning "Installation script may be missing help option"
    fi
else
    print_error "Installation script not found"
    exit 1
fi

echo "=== All tests passed! ==="
echo "The dotfiles configuration appears to be safe and functional."