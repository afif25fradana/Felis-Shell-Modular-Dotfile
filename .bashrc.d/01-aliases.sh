#!/bin/bash

# Environment Detection
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    export BASHRC_ENV="wsl"
    alias open='explorer.exe'
elif [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    export BASHRC_ENV="hyprland"
elif [[ -n "$SSH_CLIENT" ]]; then
    export BASHRC_ENV="ssh"
else
    export BASHRC_ENV="local"
fi

# PATH Management
if [[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Environment Variables
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-firefox}"

# Better history settings
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTTIMEFORMAT='%F %T '

# General & Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Modern replacements with fallbacks
if command -v eza >/dev/null; then
    alias ll='eza -lha --icons --git --group-directories-first'
    alias ls='eza --icons --git -F --group-directories-first'
    alias tree='eza --tree --icons'
else
    alias ll='ls -lha --color=auto --group-directories-first'
    alias ls='ls -F --color=auto --group-directories-first'
fi

if command -v bat >/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catt='bat --paging=auto'
elif command -v batcat >/dev/null; then
    # Ubuntu/Debian often has bat as batcat
    alias cat='batcat --paging=never --style=plain'
    alias catt='batcat --paging=auto'
else
    alias cat='cat'
fi

if command -v fd >/dev/null; then
    alias find='fd'
elif command -v fdfind >/dev/null; then
    # Ubuntu/Debian has fd as fdfind
    alias find='fdfind'
fi

if command -v rg >/dev/null; then
    alias grep='rg'
elif command -v ag >/dev/null; then
    alias grep='ag'
else
    alias grep='grep --color=auto'
fi

# System & Package Management
if command -v yay >/dev/null; then
    alias update='yay -Syu'
    alias install='yay -S'
    alias search='yay -Ss'
    alias remove='yay -Rns'
elif command -v paru >/dev/null; then
    alias update='paru -Syu'
    alias install='paru -S'
    alias search='paru -Ss'
    alias remove='paru -Rns'
elif command -v pacman >/dev/null; then
    alias update='sudo pacman -Syu'
    alias install='sudo pacman -S'
    alias search='pacman -Ss'
    alias remove='sudo pacman -Rns'
elif command -v apt >/dev/null; then
    alias update='sudo apt update && sudo apt upgrade'
    alias install='sudo apt install'
    alias search='apt search'
    alias remove='sudo apt remove'
fi

# System monitoring
if command -v btop >/dev/null; then
    alias top='btop'
elif command -v htop >/dev/null; then
    alias top='htop'
fi

# Git Workflow
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gs='git status -sb'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gll='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'

# Networking
if command -v ip >/dev/null; then
    alias myipaddr="ip -4 addr show | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1'"
    alias myip6="ip -6 addr show | grep -oP 'inet6 \K[0-9a-f:]+' | grep -v '::1'"
else
    alias myipaddr="ifconfig | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1'"
fi

alias ports='netstat -tulanp'
alias ping='ping -c 5'

# Development
# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'

# Enhanced Python development
alias pyserve='python3 -m http.server'
alias pytime='python3 -m timeit'
alias pyjson='python3 -m json.tool'
alias pydeps='python3 -m pipdeptree'
alias pycheck='python3 -m py_compile'
alias pyver='python3 --version'

# Virtual environment management
alias vact='source .venv/bin/activate'
alias vdeact='deactivate'
alias vpip='python3 -m pip'

# Node.js
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nt='npm test'
alias nr='npm run'
alias ns='npm start'

# Enhanced Node.js development
alias nls='npm ls'
alias nout='npm outdated'
alias nup='npm update'
alias nclean='rm -rf node_modules && rm -f package-lock.json'
alias nreinstall='nclean && npm install'
alias ncheck='npm audit'
alias nfix='npm audit fix'

# Web development tools
alias serve='npx serve'
alias live='npx live-server'
alias http='npx http-server'

# Docker (if available)
if command -v docker >/dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias di='docker images'
    alias drm='docker rm'
    alias drmi='docker rmi'
fi

# Utility Aliases
alias reload='source ~/.bashrc'
alias h='history'
alias j='jobs -l'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Quick edit configs
alias bashrc='${EDITOR} ~/.bashrc'
alias aliases='${EDITOR} ~/.bashrc.d/01-aliases.sh'

# Shell scripting development
alias checkbash='shellcheck'
alias checkbashfmt='shfmt -i 2 -ci -w'
alias bashlint='bash -n'
alias perm='chmod +x'

# File and directory operations
alias lspath='echo $PATH | tr ":" "\n"'
alias fstree='find . -type f | sed -e "s/[^-][^\/]*\//--/g" -e "s/^/   /" -e "s/-/|/"'
alias biggest='du -hsx * | sort -rh | head -20'

# GitHub workflow helpers
alias ghpr='gh pr create --web'
alias ghi='gh issue list'
alias ghv='gh repo view --web'
alias ghc='gh repo clone'

# Random image fastfetch
alias ff='$HOME/.local/bin/random-fastfetch.sh'

# System info with random image fastfetch
alias sysinfo='$HOME/.local/bin/random-fastfetch.sh'

# Context-aware aliases
if [[ -f "package.json" ]]; then
    alias start='npm start'
    alias test='npm test'
    alias dev='npm run dev'
elif [[ -f "Cargo.toml" ]]; then
    alias run='cargo run'
    alias test='cargo test'
    alias build='cargo build'
elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
    alias run='python main.py'
    alias test='pytest'
fi

# Fun Stuff
if command -v fortune >/dev/null && command -v cowsay >/dev/null; then
    alias wisdom='fortune | cowsay'
fi
