#!/bin/bash
#
# ~/.bashrc.d/functions/system.sh - System Maintenance Functions
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- System Maintenance Functions ---
sysclean() {
    print_info "Starting system cleanup..."

    # Check for different package managers and clean accordingly
    if command -v pacman >/dev/null; then
        # Arch Linux
        sudo -v || return 1

        print_info "Cleaning pacman cache..."
        sudo pacman -Sc --noconfirm

        print_info "Removing orphan packages..."
        local orphans
        orphans=$(pacman -Qtdq 2>/dev/null)
        if [[ -n "$orphans" ]]; then
            echo "$orphans" | sudo pacman -Rns --noconfirm -
            print_success "Removed orphan packages"
        else
            print_info "No orphan packages found"
        fi

        # Clean AUR helper cache if available
        if command -v yay >/dev/null; then
            print_info "Cleaning yay cache..."
            yay -Sc --noconfirm
        elif command -v paru >/dev/null; then
            print_info "Cleaning paru cache..."
            paru -Sc --noconfirm
        fi

    elif command -v apt >/dev/null; then
        # Debian/Ubuntu
        sudo -v || return 1

        print_info "Cleaning apt cache..."
        sudo apt autoremove -y
        sudo apt autoclean
        sudo apt clean

    elif command -v dnf >/dev/null; then
        # Fedora
        sudo -v || return 1

        print_info "Cleaning dnf cache..."
        sudo dnf clean all
        sudo dnf autoremove -y

    elif command -v yum >/dev/null; then
        # Older Fedora/RHEL/CentOS
        sudo -v || return 1

        print_info "Cleaning yum cache..."
        sudo yum clean all
        sudo yum autoremove -y

    elif command -v zypper >/dev/null; then
        # openSUSE
        sudo -v || return 1

        print_info "Cleaning zypper cache..."
        sudo zypper clean
        sudo zypper remove --clean-deps

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

    print_success "System cleanup completed!"
}

# Enhanced service management
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

    sudo -v || return 1

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