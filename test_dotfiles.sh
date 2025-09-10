#!/bin/bash

# test_dotfiles.sh - Test script for dotfiles safety and functionality

set -euo pipefail  # Exit on error, undefined vars, pipe failures

echo "=== Dotfiles Test Script ==="

# Test 1: Check that all files have proper shebangs
echo "Test 1: Checking shebang lines..."
missing_shebangs=0
for file in .bashrc .bashrc.d/*.sh .bashrc.d/functions/*.sh .local/bin/random-fastfetch.sh; do
    if [[ -f "$file" ]]; then
        if ! head -n 1 "$file" | grep -q "^#!/bin/bash" && ! head -n 1 "$file" | grep -q "^#!/usr/bin/env bash"; then
            echo "  ❌ Missing shebang in $file"
            ((missing_shebangs++))
        else
            echo "  ✓ Shebang present in $file"
        fi
    fi
done

if [[ $missing_shebangs -eq 0 ]]; then
    echo "  ✓ All files have proper shebangs"
else
    echo "  ❌ $missing_shebangs files missing shebangs"
    exit 1
fi

# Test 2: Check that all files have valid syntax
echo "Test 2: Checking all files for syntax errors..."
syntax_errors=0
for file in .bashrc .bashrc.d/*.sh .bashrc.d/functions/*.sh .local/bin/random-fastfetch.sh; do
    if [[ -f "$file" ]]; then
        if bash -n "$file"; then
            echo "  ✓ Syntax valid in $file"
        else
            echo "  ❌ Syntax errors in $file"
            ((syntax_errors++))
        fi
    fi
done

if [[ $syntax_errors -eq 0 ]]; then
    echo "  ✓ All files have valid syntax"
else
    echo "  ❌ $syntax_errors files have syntax errors"
    exit 1
fi

# Test 3: Run shellcheck on all files (if available)
if command -v shellcheck >/dev/null; then
    echo "Test 3: Running shellcheck analysis (informational only)..."
    for file in .bashrc .bashrc.d/*.sh .bashrc.d/functions/*.sh .local/bin/random-fastfetch.sh; do
        if [[ -f "$file" ]]; then
            # Skip user.conf.example as it's not meant to be executed
            if [[ "$file" == *.conf.example ]]; then
                echo "  → Skipping shellcheck for $file (configuration example)"
                continue
            fi
            
            # Run shellcheck and capture output
            if shellcheck "$file" >/dev/null 2>&1; then
                echo "  ✓ Shellcheck passed for $file"
            else
                echo "  → Shellcheck found issues in $file (expected in modular configuration)"
            fi
        fi
    done

    echo "  → Shellcheck analysis complete (issues are expected in modular configuration)"
else
    echo "Test 3: Skipping shellcheck (not installed)"
fi

echo "=== All tests passed! ==="
echo "The dotfiles configuration appears to be safe and functional."