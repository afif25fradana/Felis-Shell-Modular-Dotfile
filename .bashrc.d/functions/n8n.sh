#!/bin/bash
#
# ~/.bashrc.d/functions/n8n.sh - n8n & Ngrok Workflow
#

# Enable pipefail for better error handling in pipelines
set -o pipefail

# --- n8n Workflow Functions ---
# Start n8n services
start-n8n() {
    # Use configurable path with fallback to default
    local n8n_dir="${N8N_DIR:-$HOME/n8n-docker}"
    
    if [[ ! -d "$n8n_dir" ]]; then
        print_error "n8n directory not found at $n8n_dir"
        return 1
    fi
    
    print_step "Starting n8n services..."
    (cd "$n8n_dir" && docker-compose up -d) || return
    print_success "n8n services started"
}

# Stop n8n services
stop-n8n() {
    # Use configurable path with fallback to default
    local n8n_dir="${N8N_DIR:-$HOME/n8n-docker}"
    
    if [[ ! -d "$n8n_dir" ]]; then
        print_error "n8n directory not found at $n8n_dir"
        return 1
    fi
    
    print_step "Stopping n8n services..."
    (cd "$n8n_dir" && docker-compose down) || return
    print_success "n8n services stopped"
}

# View n8n container logs
logs-n8n() {
    # Use configurable path with fallback to default
    local n8n_dir="${N8N_DIR:-$HOME/n8n-docker}"
    
    if [[ ! -d "$n8n_dir" ]]; then
        print_error "n8n directory not found at $n8n_dir"
        return 1
    fi
    
    print_step "Showing n8n container logs..."
    (cd "$n8n_dir" && docker-compose logs -f) || return
}

# --- n8n & Ngrok Workflow ---
# Starts ngrok tunnel, updates .env file, and starts n8n services
start-n8n-ngrok() {
    # Use configurable path with fallback to default
    local n8n_dir="${N8N_DIR:-$HOME/n8n-docker}"
    local env_file="$n8n_dir/.env"

    if ! command -v ngrok >/dev/null; then
        print_error "ngrok is not installed or not in PATH."
        return 1
    fi

    if ! command -v jq >/dev/null; then
        print_error "jq is not installed. Please install it to parse ngrok API response."
        print_info "Hint: sudo pacman -S jq"
        return 1
    fi

    if [[ ! -f "$env_file" ]]; then
        print_error ".env file not found at $env_file"
        return 1
    fi

    print_step "Starting ngrok tunnel for n8n in the background..."
    # Kill any existing ngrok process to start fresh
    killall ngrok 2>/dev/null
    # Start ngrok and log its output
    ngrok http 5678 --log=stdout >/tmp/ngrok.log &
    sleep 2 # Give ngrok a moment to establish the tunnel

    print_step "Fetching public URL from ngrok API..."
    # Fetch the public URL from the local ngrok API
    local public_url
    public_url=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[] | select(.proto=="https") | .public_url')

    if [[ -z "$public_url" || "$public_url" == "null" ]]; then
        print_error "Failed to get public URL from ngrok."
        print_info "Check ngrok status with: cat /tmp/ngrok.log"
        return 1
    fi

    print_success "Got public URL: $public_url"

    print_step "Updating WEBHOOK_URL in .env file..."
    # Use sed to replace the WEBHOOK_URL value. Works even if it's empty.
    sed -i "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$public_url|" "$env_file"

    print_step "Starting n8n and postgres containers..."
    (cd "$n8n_dir" && docker-compose up -d) || return

    print_success "n8n is starting up and accessible at: $public_url"
}

# --- n8n Aliases ---
# These aliases need to be defined after the functions
alias n8n-start='start-n8n'
alias n8n-stop='stop-n8n'
alias n8n-logs='logs-n8n'
alias n8n-ngrok='start-n8n-ngrok'