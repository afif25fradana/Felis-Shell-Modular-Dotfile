#!/bin/bash
#
# ~/.bashrc.d/functions/network.sh - Network Functions
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- Network Functions ---
myip() {
    print_info "Network Information:"

    # Local IP addresses
    if command -v ip >/dev/null; then
        local ips
        ips=$(ip -4 addr show | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1')
        if [[ -n "$ips" ]]; then
            echo -e "${C_CYAN}Local IPs:${C_RESET}"
            while IFS= read -r line; do
                echo "  $line"
            done <<< "$ips"
        fi
    fi

    # Public IP address
    print_info "Checking public IP..."
    local public_ip
    public_ip=$(curl -s --connect-timeout 5 https://ipinfo.io/ip 2>/dev/null || \
               curl -s --connect-timeout 5 https://icanhazip.com 2>/dev/null || \
               echo "Unable to determine")
    echo -e "${C_CYAN}Public IP:${C_RESET} $public_ip"
}

# Port checker
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