#!/bin/bash

# test_dotfiles.sh - Test script for dotfiles safety and functionality

# Removed set -euo pipefail to avoid issues with the test script itself
# set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Default configuration
DEBUG=${DEBUG:-false}
VERBOSE=${VERBOSE:-false}
EXIT_ON_WARNING=${EXIT_ON_WARNING:-false}

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
print_debug() { 
    if [[ "$DEBUG" == "true" ]]; then 
        echo -e "${MAGENTA}DEBUG${NC} $*" >&2
    fi
}
print_verbose() { 
    if [[ "$VERBOSE" == "true" ]]; then 
        echo -e "${CYAN}VERBOSE${NC} $*"
    fi
}

# Debug function
debug_pause() {
    if [[ "$DEBUG" == "true" ]]; then
        read -p "Press Enter to continue..." </dev/tty
    fi
}

# Display help
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Test script for dotfiles safety and functionality.

OPTIONS:
    -h, --help          Show this help message
    -d, --debug         Enable debug mode (pause between tests)
    -v, --verbose       Enable verbose output
    -w, --exit-on-warning Exit on warnings in addition to errors
    --list-tests        List all available tests
    --run-test TEST     Run a specific test by name

EXAMPLES:
    $0                  Run all tests
    $0 -d               Run all tests with debug pauses
    $0 -v               Run all tests with verbose output
    $0 --run-test syntax Run only the syntax test

EOF
}

# List all tests
list_tests() {
    echo "Available tests:"
    echo "  shebang         Check shebang lines in scripts"
    echo "  syntax          Check syntax validity"
    echo "  shellcheck      Run shellcheck analysis"
    echo "  common          Check for common issues"
    echo "  install         Verify installation script"
    echo "  env             Validate environment setup"
    echo "  deps            Check dependencies"
    echo "  integration     Run integration tests"
}

# Function to find all relevant files
find_dotfiles() {
    local files=()
    
    print_debug "Finding dotfiles..."
    
    # Add root-level files
    for file in .bashrc .gitconfig .inputrc .editorconfig; do
        if [[ -f "$file" ]]; then
            files+=("$file")
            print_verbose "Found root file: $file"
        fi
    done
    
    # Add .bashrc.d files
    if [[ -d ".bashrc.d" ]]; then
        while IFS= read -r -d '' file; do
            # Only add if not already in functions directory (to avoid duplicates)
            if [[ "$file" != ".bashrc.d/functions/"* ]]; then
                files+=("$file")
                print_verbose "Found .bashrc.d file: $file"
            fi
        done < <(find .bashrc.d -name "*.sh" -type f -print0)
    fi
    
    # Add function files
    if [[ -d ".bashrc.d/functions" ]]; then
        while IFS= read -r -d '' file; do
            files+=("$file")
            print_verbose "Found function file: $file"
        done < <(find .bashrc.d/functions -name "*.sh" -type f -print0)
    fi
    
    # Add .local/bin scripts
    if [[ -d ".local/bin" ]]; then
        while IFS= read -r -d '' file; do
            files+=("$file")
            print_verbose "Found bin script: $file"
        done < <(find .local/bin -type f -print0)
    fi
    
    # Add root-level scripts
    if [[ -f "random-fastfetch.sh" ]]; then
        files+=("random-fastfetch.sh")
        print_verbose "Found random-fastfetch.sh"
    fi
    
    print_debug "Total files found: ${#files[@]}"
    # Print each file on a separate line to avoid issues with echo
    for file in "${files[@]}"; do
        echo "$file"
    done
}

# Test 1: Check that all files have proper shebangs
test_shebang() {
    echo "Test 1: Checking shebang lines..."
    local missing_shebangs=0
    local total_files=0
    
    # Get the list of files
    local files_list
    files_list=$(find_dotfiles)
    
    print_debug "Files list: $files_list"
    
    # Convert files_list to array to avoid issues with while loop
    local files_array=()
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            files_array+=("$file")
        fi
    done <<< "$files_list"
    
    # Process each file
    for file in "${files_array[@]}"; do
        if [[ -f "$file" ]]; then
            print_debug "Checking file: $file"
            # Only check shell scripts for shebangs
            if [[ "$file" == *.sh ]] || (head -n 1 "$file" 2>/dev/null | grep -q "^#!.*bash" 2>/dev/null); then
                ((total_files++))
                if ! head -n 1 "$file" | grep -q "^#!/bin/bash" && ! head -n 1 "$file" | grep -q "^#!/usr/bin/env bash"; then
                    # Configuration files and non-executable files don't need shebangs
                    if [[ "$file" == *.conf ]] || [[ "$file" == *.conf.example ]] || [[ "$file" == *.md ]] || [[ "$file" == *.txt ]]; then
                        print_verbose "Skipping shebang check for configuration file: $file"
                    else
                        print_error "Missing shebang in $file"
                        ((missing_shebangs++))
                    fi
                else
                    print_success "Shebang present in $file"
                fi
            else
                print_verbose "Skipping shebang check for non-shell file: $file"
            fi
        else
            print_debug "Skipping non-existent file: $file"
        fi
    done
    
    if [[ $missing_shebangs -eq 0 ]]; then
        print_success "All ${total_files} shell files have proper shebangs"
        return 0
    else
        print_error "$missing_shebangs files missing shebangs"
        return 1
    fi
}

# Test 2: Check that all files have valid syntax
test_syntax() {
    echo "Test 2: Checking all files for syntax errors..."
    local syntax_errors=0
    local total_files=0
    
    # Get the list of files
    local files_list
    files_list=$(find_dotfiles)
    
    print_debug "Files list: $files_list"
    
    # Convert files_list to array to avoid issues with while loop
    local files_array=()
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            files_array+=("$file")
        fi
    done <<< "$files_list"
    
    # Process each file
    for file in "${files_array[@]}"; do
        if [[ -f "$file" ]]; then
            print_debug "Checking file: $file"
            # Only check shell scripts for syntax
            if [[ "$file" == *.sh ]] || (head -n 1 "$file" 2>/dev/null | grep -q "^#!.*bash" 2>/dev/null); then
                ((total_files++))
                print_debug "Checking syntax for shell script: $file"
                if bash -n "$file"; then
                    print_success "Syntax valid in $file"
                else
                    print_error "Syntax errors in $file"
                    ((syntax_errors++))
                fi
            else
                print_verbose "Skipping syntax check for non-shell file: $file"
            fi
        else
            print_debug "Skipping non-existent file: $file"
        fi
    done
    
    if [[ $syntax_errors -eq 0 ]]; then
        print_success "All ${total_files} shell files have valid syntax"
        return 0
    else
        print_error "$syntax_errors files have syntax errors"
        return 1
    fi
}

# Test 3: Run shellcheck on all files (if available)
test_shellcheck() {
    if command -v shellcheck >/dev/null; then
        echo "Test 3: Running shellcheck analysis..."
        local shellcheck_issues=0
        local total_files=0
        
        # Get the list of files
        local files_list
        files_list=$(find_dotfiles)
        
        print_debug "Files list: $files_list"
        
        # Convert files_list to array to avoid issues with while loop
        local files_array=()
        while IFS= read -r file; do
            if [[ -n "$file" ]]; then
                files_array+=("$file")
            fi
        done <<< "$files_list"
        
        # Process each file
        for file in "${files_array[@]}"; do
            if [[ -f "$file" ]]; then
                print_debug "Checking file: $file"
                # Only check shell scripts with shellcheck
                if [[ "$file" == *.sh ]] || (head -n 1 "$file" 2>/dev/null | grep -q "^#!.*bash" 2>/dev/null); then
                    # Skip user.conf.example as it's not meant to be executed
                    if [[ "$file" == *.conf.example ]]; then
                        print_info "Skipping shellcheck for $file (configuration example)"
                        continue
                    fi
                    
                    ((total_files++))
                    # Run shellcheck and capture output
                    if shellcheck_output=$(shellcheck "$file" 2>&1); then
                        print_success "Shellcheck passed for $file"
                    else
                        print_warning "Shellcheck found issues in $file"
                        if [[ "$VERBOSE" == "true" ]]; then
                            echo "$shellcheck_output"
                        fi
                        ((shellcheck_issues++))
                        if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                            return 1
                        fi
                    fi
                else
                    print_verbose "Skipping shellcheck for non-shell file: $file"
                fi
            else
                print_debug "Skipping non-existent file: $file"
            fi
        done
        
        if [[ $shellcheck_issues -eq 0 ]]; then
            print_success "Shellcheck analysis complete - no issues found in ${total_files} files"
            return 0
        else
            print_warning "Shellcheck analysis complete - $shellcheck_issues files had issues"
            if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                return 1
            fi
            return 0
        fi
    else
        echo "Test 3: Skipping shellcheck (not installed)"
        return 0
    fi
}

# Test 4: Check for common issues in specific files
test_common() {
    echo "Test 4: Checking for common issues..."
    local common_issues=0
    
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
                print_warning "Missing alias $alias in 01-aliases.sh"
                if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                    ((common_issues++))
                fi
            fi
        done
    fi
    
    # Check prompt file for build_prompt function
    if [[ -f ".bashrc.d/02-prompt.sh" ]]; then
        if grep -q "build_prompt" ".bashrc.d/02-prompt.sh"; then
            print_success "Found build_prompt function in 02-prompt.sh"
        else
            print_warning "Missing build_prompt function in 02-prompt.sh"
            if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                ((common_issues++))
            fi
        fi
    fi
    
    # Check hooks file for cd function
    if [[ -f ".bashrc.d/03-hooks.sh" ]]; then
        if grep -q "^cd()" ".bashrc.d/03-hooks.sh"; then
            print_success "Found cd function in 03-hooks.sh"
        else
            print_warning "Missing cd function in 03-hooks.sh"
            if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                ((common_issues++))
            fi
        fi
    fi
    
    if [[ $common_issues -eq 0 ]]; then
        print_success "No critical common issues found"
        return 0
    else
        print_error "$common_issues critical common issues found"
        return 1
    fi
}

# Test 5: Verify installation script
test_install() {
    echo "Test 5: Verifying installation script..."
    if [[ -f "install.sh" ]]; then
        if bash -n "install.sh"; then
            print_success "Installation script syntax is valid"
        else
            print_error "Installation script has syntax errors"
            return 1
        fi
        
        # Check if install script has help option
        if ./install.sh --help >/dev/null 2>&1; then
            print_success "Installation script has help option"
        else
            print_warning "Installation script may be missing help option"
            if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                return 1
            fi
        fi
        
        # Test dry-run mode
        if ./install.sh --dry-run >/dev/null 2>&1; then
            print_success "Installation script supports dry-run mode"
        else
            print_warning "Installation script may have issues with dry-run mode"
            if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                return 1
            fi
        fi
    else
        print_error "Installation script not found"
        return 1
    fi
    
    return 0
}

# Test 6: Environment validation
test_env() {
    echo "Test 6: Validating environment setup..."
    local env_issues=0
    
    # Check bash version
    if ((BASH_VERSINFO[0] < 4)); then
        print_warning "Bash version 4.0+ recommended, you have ${BASH_VERSION}"
        if [[ "$EXIT_ON_WARNING" == "true" ]]; then
            ((env_issues++))
        fi
    else
        print_success "Bash version is sufficient: ${BASH_VERSION}"
    fi
    
    # Check if we're in the right directory
    if [[ ! -f ".bashrc" ]]; then
        print_error "Not in the dotfiles directory (missing .bashrc)"
        ((env_issues++))
    else
        print_success "In the correct dotfiles directory"
    fi
    
    # Check if .bashrc.d directory exists
    if [[ ! -d ".bashrc.d" ]]; then
        print_error "Missing .bashrc.d directory"
        ((env_issues++))
    else
        print_success ".bashrc.d directory exists"
    fi
    
    if [[ $env_issues -eq 0 ]]; then
        print_success "Environment validation passed"
        return 0
    else
        print_error "$env_issues environment issues found"
        return 1
    fi
}

# Test 7: Dependency checking
test_deps() {
    echo "Test 7: Checking dependencies..."
    local missing_deps=0
    local deps=("bash" "find" "grep" "awk" "sed")
    
    # Check for shellcheck specifically if we're going to use it
    if command -v shellcheck >/dev/null; then
        deps+=("shellcheck")
    fi
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            print_success "Found dependency: $dep"
        else
            print_error "Missing dependency: $dep"
            ((missing_deps++))
        fi
    done
    
    if [[ $missing_deps -eq 0 ]]; then
        print_success "All dependencies satisfied"
        return 0
    else
        print_error "$missing_deps dependencies missing"
        return 1
    fi
}

# Test 8: Integration tests (sourcing dotfiles)
test_integration() {
    echo "Test 8: Running integration tests..."
    local integration_issues=0
    
    # Test sourcing .bashrc in a subshell
    if bash -c "source .bashrc && echo 'SUCCESS'" >/dev/null 2>&1; then
        print_success "Successfully sourced .bashrc"
    else
        print_error "Failed to source .bashrc"
        ((integration_issues++))
    fi
    
    # Test sourcing individual module files
    if [[ -d ".bashrc.d" ]]; then
        # Get the list of files
        local files_list
        files_list=$(find_dotfiles)
        
        print_debug "Files list: $files_list"
        
        # Convert files_list to array to avoid issues with while loop
        local files_array=()
        while IFS= read -r file; do
            if [[ -n "$file" ]]; then
                files_array+=("$file")
            fi
        done <<< "$files_list"
        
        # Process each file
        for module in "${files_array[@]}"; do
            if [[ -f "$module" ]] && [[ "$module" == *.sh ]]; then
                print_debug "Testing sourcing of: $module"
                if bash -c "source "$module" && echo 'SUCCESS' || echo 'FAILED'" 2>/dev/null | grep -q "SUCCESS"; then
                    print_success "Successfully sourced $module"
                else
                    print_warning "Issues when sourcing $module"
                    if [[ "$EXIT_ON_WARNING" == "true" ]]; then
                        ((integration_issues++))
                    fi
                fi
            fi
        done
    fi
    
    if [[ $integration_issues -eq 0 ]]; then
        print_success "Integration tests passed"
        return 0
    else
        print_error "$integration_issues integration issues found"
        return 1
    fi
}

# Run all tests
run_all_tests() {
    echo "=== Dotfiles Test Script ==="
    local failed_tests=0
    
    test_shebang || ((failed_tests++))
    debug_pause
    
    test_syntax || ((failed_tests++))
    debug_pause
    
    test_shellcheck || ((failed_tests++))
    debug_pause
    
    test_common || ((failed_tests++))
    debug_pause
    
    test_install || ((failed_tests++))
    debug_pause
    
    test_env || ((failed_tests++))
    debug_pause
    
    test_deps || ((failed_tests++))
    debug_pause
    
    test_integration || ((failed_tests++))
    debug_pause
    
    if [[ $failed_tests -eq 0 ]]; then
        echo "=== All tests passed! ==="
        echo "The dotfiles configuration appears to be safe and functional."
        return 0
    else
        print_error "$failed_tests test suites failed"
        return 1
    fi
}

# Run a specific test
run_specific_test() {
    local test_name="$1"
    case "$test_name" in
        shebang)
            test_shebang
            ;;
        syntax)
            test_syntax
            ;;
        shellcheck)
            test_shellcheck
            ;;
        common)
            test_common
            ;;
        install)
            test_install
            ;;
        env)
            test_env
            ;;
        deps)
            test_deps
            ;;
        integration)
            test_integration
            ;;
        *)
            print_error "Unknown test: $test_name"
            return 1
            ;;
    esac
}

# Parse command line arguments
SPECIFIC_TEST=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--debug)
            DEBUG=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -w|--exit-on-warning)
            EXIT_ON_WARNING=true
            shift
            ;;
        --list-tests)
            list_tests
            exit 0
            ;;
        --run-test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ -n "$SPECIFIC_TEST" ]]; then
        run_specific_test "$SPECIFIC_TEST"
    else
        run_all_tests
    fi
fi