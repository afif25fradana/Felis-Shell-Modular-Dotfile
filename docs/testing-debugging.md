# Dotfiles Testing and Debugging Guide

## Test Script (`test_dotfiles.sh`)

The enhanced test script provides comprehensive testing of your dotfiles with multiple test suites.

### Usage

```bash
# Run all tests
./test_dotfiles.sh

# Run with debug mode (pauses between tests)
./test_dotfiles.sh -d

# Run with verbose output
./test_dotfiles.sh -v

# Run with both debug and verbose
./test_dotfiles.sh -d -v

# Exit on warnings as well as errors
./test_dotfiles.sh -w

# List all available tests
./test_dotfiles.sh --list-tests

# Run a specific test
./test_dotfiles.sh --run-test syntax

# Show help
./test_dotfiles.sh --help
```

### Test Suites

1. **Shebang Check** - Verifies all shell scripts have proper shebang lines
2. **Syntax Check** - Validates syntax of all shell scripts
3. **Shellcheck Analysis** - Runs shellcheck on all scripts (if available)
4. **Common Issues** - Checks for common configuration problems
5. **Installation Script** - Verifies the installation script works correctly
6. **Environment Validation** - Checks that the environment is properly set up
7. **Dependency Check** - Ensures all required dependencies are available
8. **Integration Tests** - Tests actual sourcing and functionality of dotfiles

## Debug Script (`debug_dotfiles.sh`)

The debug script helps troubleshoot issues with your dotfiles configuration.

### Usage

```bash
# Run debug session
./debug_dotfiles.sh

# Run debug session with verbose output
./debug_dotfiles.sh -v

# Show help
./debug_dotfiles.sh --help
```

The debug script will:
- Check directory structure and essential files
- Verify bash version compatibility
- Test sourcing of .bashrc
- Check PATH configuration
- Test custom functions and aliases
- Provide an interactive shell for manual testing

## Installation Script Debugging

The installation script also has built-in debugging capabilities:

```bash
# Run installation in dry-run mode (shows what would happen)
./install.sh --dry-run

# Run installation with debug output
./install.sh --debug

# Run installation with both dry-run and debug
./install.sh --dry-run --debug

# Show help
./install.sh --help
```