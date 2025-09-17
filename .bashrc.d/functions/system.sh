#!/bin/bash
#
# ~/.bashrc.d/functions/system.sh - System Maintenance Functions
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- System Maintenance Functions ---

# Performs comprehensive system cleanup across multiple distributions.
#
# This function automates the process of cleaning up system caches, removing orphaned packages,
# and clearing user caches. It intelligently detects your package manager (pacman, apt, dnf, etc.)
# and executes the appropriate cleanup commands for your specific distribution.
#
# The function handles various Linux distributions including Arch Linux, Ubuntu/Debian, Fedora,
# openSUSE, and others, making it a versatile tool for system maintenance.
#
# Returns:
#   0 on success, 1 on failure
#
# @example
#   sysclean
sysclean() {
    local has_error=false
    local has_performed_action=false
    
    print_info "Starting system cleanup..."

    # Check for root privileges
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root"
        return 1
    fi

    # Check available disk space before cleanup
    local available_space
    available_space=$(df -m / | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 1024 ]]; then  # Less than 1GB
        print_warning "Low disk space detected: ${available_space}MB available"
    fi

    # Function to handle command execution with error checking
    run_cmd() {
        local cmd=$1
        local msg=$2
        if ! eval "$cmd"; then
            print_error "Failed: $msg"
            has_error=true
            return 1
        fi
        has_performed_action=true
        return 0
    }

    # Check for different package managers and clean accordingly
    if command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        if ! sudo -v; then
            print_error "Failed to acquire sudo privileges"
            return 1
        fi

        print_info "Cleaning pacman cache..."
        run_cmd "sudo pacman -Sc --noconfirm" "pacman cache cleanup"

        print_info "Removing orphan packages..."
        local orphans
        if orphans=$(pacman -Qtdq 2>/dev/null); then
            if [[ -n "$orphans" ]]; then
                if echo "$orphans" | run_cmd "sudo pacman -Rns --noconfirm -" "orphan package removal"; then
                    print_success "Removed orphan packages"
                fi
            else
                print_info "No orphan packages found"
            fi
        else
            print_error "Failed to check for orphan packages"
            has_error=true
        fi

        # Clean AUR helper cache if available
        if command -v yay >/dev/null 2>&1; then
            print_info "Cleaning yay cache..."
            run_cmd "yay -Sc --noconfirm" "yay cache cleanup"
        elif command -v paru >/dev/null 2>&1; then
            print_info "Cleaning paru cache..."
            run_cmd "paru -Sc --noconfirm" "paru cache cleanup"
        fi
    elif command -v apt >/dev/null; then
        # Debian/Ubuntu
        if ! sudo -v; then
            print_error "Failed to acquire sudo privileges"
            return 1
        fi

        print_info "Cleaning apt cache..."
        run_cmd "sudo apt autoremove -y" "apt autoremove"
        run_cmd "sudo apt autoclean" "apt autoclean"
        run_cmd "sudo apt clean" "apt clean"

    elif command -v dnf >/dev/null; then
        # Fedora
        if ! sudo -v; then
            print_error "Failed to acquire sudo privileges"
            return 1
        fi

        print_info "Cleaning dnf cache..."
        run_cmd "sudo dnf clean all" "dnf clean all"
        run_cmd "sudo dnf autoremove -y" "dnf autoremove"

    elif command -v yum >/dev/null; then
        # Older Fedora/RHEL/CentOS
        if ! sudo -v; then
            print_error "Failed to acquire sudo privileges"
            return 1
        fi

        print_info "Cleaning yum cache..."
        run_cmd "sudo yum clean all" "yum clean all"
        run_cmd "sudo yum autoremove -y" "yum autoremove"

    elif command -v zypper >/dev/null; then
        # openSUSE
        if ! sudo -v; then
            print_error "Failed to acquire sudo privileges"
            return 1
        fi

        print_info "Cleaning zypper cache..."
        run_cmd "sudo zypper clean" "zypper clean"
        run_cmd "sudo zypper remove --clean-deps" "zypper remove --clean-deps"

    else
        print_warning "Unknown package manager - manual cleanup required"
        return 1
    fi

    # Clean user caches
    print_info "Cleaning user caches..."
    [[ -d "$HOME/.cache" ]] && find "$HOME/.cache" -type f -atime +30 -delete 2>/dev/null
    [[ -d "$HOME/.local/share/Trash" ]] && rm -rf "$HOME/.local/share/Trash"/* 2>/dev/null

    # Clean logs if we have permission
    if [[ -w /var/log ]]; then
        print_info "Cleaning system logs..."
        sudo journalctl --vacuum-time=7d 2>/dev/null
    fi

    # Final status check
    if ! $has_performed_action; then
        print_error "No package manager found or no cleanup actions performed"
        return 1
    fi

    if $has_error; then
        print_warning "Cleanup completed with some errors"
        return 1
    else
        print_success "System cleanup completed successfully"
        return 0
    fi
}

# Manages systemd services with a user-friendly interface.
#
# This function provides a simplified way to control systemd services, supporting both
# system services and user services. It handles the sudo requirements automatically
# and provides clear feedback about the operation results.
#
# @param $1 - The action to perform (start, stop, restart, status, enable, disable). Required.
# @param $2 - The name of the service to manage. Required.
# @param $3 - (Optional) Add --user flag to manage user services instead of system services.
#
# @example
#   serv start nginx
#   serv restart docker
#   serv status apache2
#   serv enable myapp --user
serv() {
    if [[ $# -lt 2 ]]; then
        print_error "Usage: serv <action> <service> [--user]"
        print_info "Actions: start, stop, restart, status, enable, disable"
        print_info "Add --user flag for user services"
        return 1
    fi

    local action="$1"
    local service="$2"
    local user_flag="$3"

    # Validate action
    case "$action" in
        start|stop|restart|status|enable|disable) ;;
        *)
            print_error "Invalid action: $action"
            return 1
            ;;
    esac

    if ! sudo -v; then
        print_error "Failed to acquire sudo privileges"
        return 1
    fi

    if [[ "$user_flag" == "--user" ]]; then
        systemctl --user "$action" "$service"
    else
        sudo systemctl "$action" "$service"
    fi

    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        print_success "Service $service $action completed"
    else
        print_error "Service $service $action failed"
    fi

    return $exit_code
}