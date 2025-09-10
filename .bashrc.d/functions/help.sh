#!/bin/bash

# Enable pipefail for better error handling in pipelines
set -o pipefail

# Enhanced Shortcut Display
shortcut() {
    cat <<EOF

${C_BOLD}${C_YELLOW}🚀 My Personal Command Shortcuts${C_RESET}

${C_CYAN}--- System & Package Management ---${C_RESET}
  ${C_GREEN}update${C_RESET}              ${C_GRAY}→ Update system packages (pacman/apt + AUR)${C_RESET}
  ${C_GREEN}install <pkg>${C_RESET}       ${C_GRAY}→ Install a package${C_RESET}
  ${C_GREEN}search <pkg>${C_RESET}        ${C_GRAY}→ Search for packages${C_RESET}
  ${C_GREEN}remove <pkg>${C_RESET}        ${C_GRAY}→ Remove a package${C_RESET}
  ${C_GREEN}sysclean${C_RESET}            ${C_GRAY}→ Comprehensive system cleanup${C_RESET}
  ${C_GREEN}serv <cmd> <srv>${C_RESET}    ${C_GRAY}→ Manage systemd services${C_RESET}
  ${C_GREEN}top${C_RESET}                 ${C_GRAY}→ Enhanced system monitor (btop/htop)${C_RESET}
  ${C_GREEN}myip${C_RESET}                ${C_GRAY}→ Show local and public IP addresses${C_RESET}
  ${C_GREEN}portcheck <port>${C_RESET}    ${C_GRAY}→ Check if a port is open${C_RESET}

${C_CYAN}--- Navigation & Files ---${C_RESET}
  ${C_GREEN}ll${C_RESET}                  ${C_GRAY}→ Detailed file listing with icons (eza/ls)${C_RESET}
  ${C_GREEN}z <name>${C_RESET}            ${C_GRAY}→ Smart directory jumping (zoxide)${C_RESET}
  ${C_GREEN}mkcd <dir>${C_RESET}          ${C_GRAY}→ Create directory and enter it${C_RESET}
  ${C_GREEN}backup <file>${C_RESET}       ${C_GRAY}→ Create timestamped backup${C_RESET}
  ${C_GREEN}newscript <name>${C_RESET}     ${C_GRAY}→ Create new bash script with template${C_RESET}
  ${C_GREEN}extract <archive>${C_RESET}   ${C_GRAY}→ Extract any archive format${C_RESET}
  ${C_GREEN}Ctrl+R${C_RESET}              ${C_GRAY}→ Interactive history search (fzf)${C_RESET}
  ${C_GREEN}Ctrl+T${C_RESET}              ${C_GRAY}→ Fuzzy file finder${C_RESET}
  ${C_GREEN}Alt+C${C_RESET}               ${C_GRAY}→ Fuzzy directory navigation${C_RESET}

${C_MAGENTA}--- GitHub Workflow ---${C_RESET}
  ${C_GREEN}ghpr${C_RESET}                 ${C_GRAY}→ Create PR in browser${C_RESET}
  ${C_GREEN}ghi${C_RESET}                  ${C_GRAY}→ List repository issues${C_RESET}
  ${C_GREEN}ghv${C_RESET}                  ${C_GRAY}→ View repository in browser${C_RESET}
  ${C_GREEN}ghc <repo>${C_RESET}           ${C_GRAY}→ Clone repository${C_RESET}
  ${C_GREEN}ghissue <title> [body]${C_RESET} ${C_GRAY}→ Create new GitHub issue${C_RESET}
  ${C_GREEN}ghstatus${C_RESET}             ${C_GRAY}→ Check repository status${C_RESET}

${C_CYAN}--- Project Management ---${C_RESET}
  ${C_GREEN}newproject <name> [type]${C_RESET} ${C_GRAY}→ Create new project (python/node/web/shell)${C_RESET}
  ${C_GREEN}pyinit [name]${C_RESET}           ${C_GRAY}→ Initialize Python project with venv${C_RESET}
  ${C_GREEN}pyinitplus [name]${C_RESET}       ${C_GRAY}→ Initialize enhanced Python project${C_RESET}
  ${C_GREEN}nodeinit [name]${C_RESET}         ${C_GRAY}→ Initialize Node.js project${C_RESET}
  ${C_GREEN}nodeinitplus [name]${C_RESET}     ${C_GRAY}→ Initialize enhanced Node.js project${C_RESET}
  ${C_GREEN}webinit [name]${C_RESET}          ${C_GRAY}→ Initialize web development project${C_RESET}

${C_YELLOW}--- Development Tools ---${C_RESET}
  ${C_GREEN}devstatus${C_RESET}             ${C_GRAY}→ Show development environment status${C_RESET}
  ${C_GREEN}dotfiles${C_RESET}              ${C_GRAY}→ Manage dotfiles (backup/restore)${C_RESET}
  ${C_GREEN}templates${C_RESET}             ${C_GRAY}→ Manage project templates${C_RESET}

${C_BLUE}--- n8n Workflow ---${C_RESET}
  ${C_GREEN}n8n-start${C_RESET}             ${C_GRAY}→ Start local n8n services (docker)${C_RESET}
  ${C_GREEN}n8n-stop${C_RESET}              ${C_GRAY}→ Stop local n8n services${C_RESET}
  ${C_GREEN}n8n-logs${C_RESET}              ${C_GRAY}→ View n8n container logs${C_RESET}
  ${C_GREEN}n8n-ngrok${C_RESET}             ${C_GRAY}→ Start n8n with a public ngrok tunnel${C_RESET}

${C_YELLOW}--- Smart Features ---${C_RESET}
  • Auto-activate Python venv when entering project dirs
  • Auto-switch Node.js version with .nvr mc files
  • Git status caching for faster prompts
  • Directory contents preview on cd
  • Exit code display in prompt
  • SSH session indicators

${C_MUTED}Type 'help <command>' for detailed help on any command${C_RESET}

EOF
}

# Enhanced Error Handling
print_debug() {
    [[ "${BASHRC_DEBUG:-false}" == "true" ]] && echo -e "${C_GRAY}🐛 DEBUG:${C_RESET} $*" >&2
}

print_step() {
    echo -e "${C_CYAN}→${C_RESET} $*"
}

# Help System
help() {
    if [[ $# -eq 0 ]]; then
        echo -e "${C_YELLOW}Available help topics:${C_RESET}"
        echo "  shortcut  - Show all custom shortcuts"
        echo "  git       - Git command help"
        echo "  dev       - Development workflow help"
        echo "  system    - System management help"
        echo "  project   - Project management help"
        echo "  github    - GitHub workflow help"
        return 0
    fi

    case "$1" in
        shortcut) shortcut ;;
        git)
            echo -e "${C_YELLOW}Git Workflow Help:${C_RESET}"
            echo "  gs     - Show repository status"
            echo "  ga     - Add specific files"
            echo "  gaa    - Add all changed files"
            echo "  gc     - Commit with message"
            echo "  gp     - Push to remote"
            echo "  gpl    - Pull from remote"
            echo "  gl     - Show commit history (graph)"
            ;;
        dev)
            echo -e "${C_YELLOW}Development Help:${C_RESET}"
            echo "  pyinit     - Set up Python project with venv, git, .gitignore"
            echo "  pyinitplus - Set up enhanced Python project with dev tools"
            echo "  nodeinit   - Set up Node.js project with npm, eslint, git"
            echo "  nodeinitplus - Set up enhanced Node.js project with TypeScript support"
            echo "  webinit    - Set up web development project structure"
            echo "  Auto-venv activation works with .venv, venv, Poetry, Pipenv"
            ;;
        system)
            echo -e "${C_YELLOW}System Management Help:${C_RESET}"
            echo "  sysclean - Clean package cache, remove orphans, clean logs"
            echo "  serv     - Manage systemd services (start/stop/restart/etc)"
            echo "  myip     - Show local and public IP addresses"
            ;;
        project)
            echo -e "${C_YELLOW}Project Management Help:${C_RESET}"
            echo "  newproject - Create new project with proper structure"
            echo "    Types: python, node, web, shell (default)"
            echo "  pyinit     - Set up Python project with venv, git, .gitignore"
            echo "  pyinitplus - Set up enhanced Python project with dev tools"
            echo "  nodeinit   - Set up Node.js project with npm, eslint, git"
            echo "  nodeinitplus - Set up enhanced Node.js project with TypeScript support"
            echo "  webinit    - Set up web development project structure"
            echo "  Auto-venv activation works with .venv, venv, Poetry, Pipenv"
            ;;
        github)
            echo -e "${C_YELLOW}GitHub Workflow Help:${C_RESET}"
            echo "  ghpr     - Create PR in browser (requires GitHub CLI)"
            echo "  ghi      - List repository issues (requires GitHub CLI)"
            echo "  ghv      - View repository in browser (requires GitHub CLI)"
            echo "  ghc      - Clone repository (requires GitHub CLI)"
            echo "  ghissue  - Create new GitHub issue from terminal"
            echo "  ghstatus - Check repository status and recent issues"
            ;;
        
        *)
            command help "$@"
            ;;
    esac
}