# VS Code (VSCodeVim)

Not symlinked by `install.sh`: VS Code rewrites its own `settings.json`.

Install VSCodeVim:

```bash
code --install-extension vscodevim.vim
```

Open `settings.json` (Cmd/Ctrl+Shift+P → "Preferences: Open User Settings (JSON)") and add:

```json
"vim.insertModeKeyBindings": [
  { "before": ["j", "k"], "after": ["<Esc>"] }
]
```

To reuse an existing `.vimrc` instead (VSCodeVim reads a subset, including `imap` and `inoremap`):

```json
"vim.vimrc.enable": true,
"vim.vimrc.path": "~/.vimrc"
```

On macOS, make holding `hjkl` repeat instead of opening the accent popup, then restart VS Code:

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```
