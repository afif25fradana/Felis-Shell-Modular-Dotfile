#!/bin/bash
#
# ~/.bashrc.d/functions/network.sh - Network Functions
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- Network Functions ---

# Displays comprehensive network information including local and public IP addresses.
#
# This function provides a quick overview of your network configuration by showing both
# local network interfaces and your public IP address. It's particularly useful for
# troubleshooting network issues or quickly checking your external IP.
#
# The function attempts to retrieve your public IP from multiple services as fallbacks,
# ensuring reliable results even if one service is unavailable.
#
# Dependencies:
#   - ip command (for local IP)
#   - curl (for public IP)
#
# @example
#   myip
myip() {
    print_info "Network Information:"
    local has_error=false

    # Check for required commands
    if ! command -v ip >/dev/null 2>&1; then
        print_warning "ip command not found. Local IP information will be limited."
        has_error=true
    fi

    if ! command -v curl >/dev/null 2>&1; then
        print_warning "curl command not found. Cannot retrieve public IP."
        has_error=true
    fi

    # Local IP addresses
    echo -e "${C_CYAN}Local IPs:${C_RESET}"
    local ips
    if command -v ip >/dev/null 2>&1; then
        ips=$(ip -4 addr show 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1') || {
            print_error "Failed to retrieve local IP addresses"
            has_error=true
        }
        if [[ -n "$ips" ]]; then
            while IFS= read -r line; do
                echo "  $line"
            done <<< "$ips"
        else
            echo "  No local IPs found (excluding loopback)"
        fi
    else
        # Fallback to hostname command
        local hostname_ip
        hostname_ip=$(hostname -I 2>/dev/null | tr -d '\n')
        if [[ -n "$hostname_ip" ]]; then
            echo "  $hostname_ip"
        else
            echo "  Unable to determine local IP"
        fi
    fi

    # Public IP address
    if command -v curl >/dev/null 2>&1; then
        print_info "Checking public IP..."
        local public_ip timeout=5
        public_ip=$(curl -s --connect-timeout "$timeout" https://ipinfo.io/ip 2>/dev/null || 
                   curl -s --connect-timeout "$timeout" https://icanhazip.com 2>/dev/null || 
                   curl -s --connect-timeout "$timeout" https://api.ipify.org 2>/dev/null || 
                   echo "Unable to determine")
        
        if [[ "$public_ip" == "Unable to determine" ]]; then
            print_error "Failed to retrieve public IP (check your internet connection)"
            has_error=true
        else
            echo -e "${C_CYAN}Public IP:${C_RESET} $public_ip"
        fi
    fi

    # Return error status if any issues occurred
    [[ "$has_error" == "true" ]] && return 1
    return 0
}

# Port checker
# Checks if a specific port is open on a given host.
#
# This function is useful for network troubleshooting, verifying if a service is
# accessible, or checking firewall configurations. It uses netcat to test the
# connection to the specified port.
#
# @param $1 - The port number to check. This is a required parameter.
# @param $2 - (Optional) The hostname or IP address to check. Defaults to localhost.
#
# @example
#   portcheck 80
#   portcheck 22 remote-server.com
#   portcheck 3306 database.local
portcheck() {
    if [[ $# -eq 0 ]]; then
        print_error "Usage: portcheck <port> [host]"
        return 1
    fi

    local port="$1"
    local host="${2:-localhost}"

    if command -v nc >/dev/null; then
        if nc -z "$host" "$port" 2>/dev/null; then
            print_success "Port $port on $host is open"
        else
            print_error "Port $port on $host is closed"
        fi
    else
        print_warning "netcat not available for port checking"
    fi
}