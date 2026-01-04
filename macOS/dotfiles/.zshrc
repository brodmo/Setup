# === Definitions ===

export PATH="$HOME/Cloud/Setup/pdfutil:$PATH"
export PATH="/opt/homebrew/opt/avr-gcc@8/bin:$PATH"

export JAVA_HOME="$HOME/Library/Java/JavaVirtualMachines/jbr-21.0.7/Contents/Home"

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim

alias ssh="TERM=xterm-256color ssh"  # for tmux

alias python=python3
alias pip=pip3

alias lg=lazygit

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ==== History ===

HISTSIZE=10000
SAVEHIST=10000

setopt INC_APPEND_HISTORY

setopt HIST_IGNORE_DUPS
zshaddhistory() { [[ $1 != (y|lg)$'\n' ]] }

# === Setup ====

touch ~/.hushlogin
PS1=$'
%F{blue}%{\e[3m%}%~%{\e[0m%}%f '

eval "$(sheldon source)"

autoload -Uz compinit;compinit

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
