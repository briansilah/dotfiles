# dotfiles

Personal tmux and neovim configurations. Works on macOS and Linux.

## What's included

- **Neovim** — [NvChad](https://nvchad.com/) v2.5 with catppuccin theme, LSP, conform.nvim, telescope, and more
- **tmux** — catppuccin theme, TPM plugins (sensible, yank, resurrect, continuum), mouse support

## Quick setup

```bash
git clone https://github.com/briansilah/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:

1. Install tmux, neovim, and git (via Homebrew on macOS, or apt/dnf/pacman on Linux)
2. Back up any existing configs (as `*.bak`) and create symlinks
3. Install [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager)

## Post-install

- **tmux** — Open tmux and press `prefix + I` to install plugins
- **neovim** — Open nvim and Lazy will auto-install plugins on first launch

## Structure

```
dotfiles/
├── install.sh
├── tmux/
│   └── tmux.conf
└── nvim/
    ├── init.lua
    ├── .stylua.toml
    ├── lazy-lock.json
    └── lua/
        ├── autocmds.lua
        ├── chadrc.lua
        ├── mappings.lua
        ├── options.lua
        ├── configs/
        │   ├── conform.lua
        │   ├── lazy.lua
        │   └── lspconfig.lua
        └── plugins/
            └── init.lua
```
