#!/usr/bin/env bash
# Symlink dotfiles into place. Safe to re-run: anything already linked is left
# alone, anything else in the way is moved to ~/.dotfiles-backup/<timestamp>/.
#
#   ./install.sh                 link everything for $SHELL
#   ./install.sh --shell bash    link the bash rcfile instead of the zsh one
#   ./install.sh --dry-run       show what would happen, touch nothing
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

usage() { echo "usage: $(basename "$0") [--dry-run] [--shell zsh|bash]" >&2; exit 2; }

DRY_RUN=0
SHELL_KIND="$(basename "${SHELL:-zsh}")"
while (($#)); do
	case "$1" in
		--dry-run) DRY_RUN=1; shift ;;
		--shell) [[ $# -ge 2 ]] || usage; SHELL_KIND="$2"; shift 2 ;;
		--shell=*) SHELL_KIND="${1#*=}"; shift ;;
		*) usage ;;
	esac
done

# src (relative to this repo) | dest
LINKS=(
	"nvim|$HOME/.config/nvim"
	"tmux/.tmux.conf|$HOME/.tmux.conf"
	"claude/statusline.py|$HOME/.claude/statusline.py"
	"shell/common.sh|$HOME/.config/shell/common.sh"
)

# The rcfile is the only shell-specific link; both rcfiles source common.sh
# from its fixed path above, so neither has to resolve its own symlink.
case "$SHELL_KIND" in
	zsh)  LINKS+=("zsh/zshrc|$HOME/.zshrc");    RCFILE="$HOME/.zshrc" ;;
	bash) LINKS+=("bash/bashrc|$HOME/.bashrc"); RCFILE="$HOME/.bashrc" ;;
	*) echo "unsupported shell: $SHELL_KIND (expected zsh or bash)" >&2; exit 2 ;;
esac

log()  { printf '  %s%s\n' "$( ((DRY_RUN)) && printf '[dry] ' )" "$*"; }
warn() { printf '  !  %s\n' "$*"; }
run()  { ((DRY_RUN)) || "$@"; }

link_one() {
	local src="$DOTFILES/$1" dest="$2"

	if [[ ! -e $src ]]; then
		warn "skip $dest — $src does not exist"
		return
	fi

	if [[ -L $dest ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
		log "ok   $dest"
		return
	fi

	if [[ -e $dest || -L $dest ]]; then
		run mkdir -p "$BACKUP"
		run mv "$dest" "$BACKUP/"
		log "moved $dest -> $BACKUP/"
	fi

	run mkdir -p "$(dirname "$dest")"
	run ln -s "$src" "$dest"
	log "link $dest -> $src"
}

echo "Linking from $DOTFILES (shell: $SHELL_KIND)"
for entry in "${LINKS[@]}"; do
	link_one "${entry%%|*}" "${entry#*|}"
done

# Dependencies the linked configs need. Reported only — nothing is installed.
echo "Checking dependencies"
missing=0
if ! command -v "$SHELL_KIND" >/dev/null; then
	warn "$SHELL_KIND not on PATH — $RCFILE will never be read"
	missing=1
fi
if ! command -v nvim >/dev/null; then
	warn "neovim not on PATH — the nvim config will not load"
	missing=1
fi
if [[ $SHELL_KIND == zsh ]]; then
	if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
		warn 'oh-my-zsh missing — zshrc will error on startup (git aliases included):'
		warn '    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
		missing=1
	fi
	zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
	for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
		if [[ ! -d "$zsh_custom/plugins/$plugin" ]]; then
			warn "$plugin missing:"
			warn "    git clone https://github.com/zsh-users/$plugin $zsh_custom/plugins/$plugin"
			missing=1
		fi
	done
fi
if ! command -v python3 >/dev/null; then
	warn "python3 not on PATH — the Claude Code status line will not render"
	missing=1
fi
# The status line only runs if settings.json points at it; that file is not
# tracked here because Claude Code rewrites it (theme, /config, plugins).
claude_settings="$HOME/.claude/settings.json"
if [[ ! -f $claude_settings ]] || ! grep -q '"statusLine"' "$claude_settings"; then
	warn "no statusLine in $claude_settings — add this block to enable it:"
	warn '    "statusLine": { "type": "command", "command": "python3 \"$HOME/.claude/statusline.py\"" }'
	missing=1
fi
((missing)) || echo "  all present"

echo "Done. Restart your shell (or: source $RCFILE)."
