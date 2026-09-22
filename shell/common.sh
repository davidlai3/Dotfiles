# Shell-agnostic environment: PATH, aliases, language toolchains.
# Sourced by both zsh/zshrc and bash/bashrc via ~/.config/shell/common.sh.
# POSIX sh only — no bashisms, no zshisms. Safe to source more than once.

# --- PATH helpers ----------------------------------------------------------
# Idempotent so re-sourcing this file does not grow $PATH without bound.
_prepend_path() { case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH" ;; esac; }
_append_path()  { case ":$PATH:" in *":$1:"*) ;; *) PATH="$PATH:$1" ;; esac; }

# --- C/C++ headers ---------------------------------------------------------
export CPLUS_INCLUDE_PATH=/usr/include/c++/11:/usr/include/x86_64-linux-gnu/c++/11
export C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu:../include

# --- PATH ------------------------------------------------------------------
_prepend_path /usr/local/texlive/2024/bin/x86_64-linux
_append_path "$HOME/.local/bin"
_append_path /opt/nvim-linux64/bin
_append_path /opt/idea/bin
_append_path /usr/local/MATLAB/R2025b/bin
_append_path /usr/local/go/bin
export PATH

unset -f _prepend_path _append_path

# --- Toolchains ------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --- Aliases ---------------------------------------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git. Under zsh these override the same names from the oh-my-zsh git plugin,
# so common.sh must be sourced after oh-my-zsh.sh.
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gl="git log"

# AI (LOL)
# alias claude="claude --dangerously-skip-permissions"
alias c="claude --dangerously-skip-permissions"
alias codex="codex --yolo"
