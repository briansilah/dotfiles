#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Darwin) OS_NAME="macOS" ;;
  Linux)  OS_NAME="Linux" ;;
  *)      error "Unsupported OS: $OS"; exit 1 ;;
esac
info "Detected OS: $OS_NAME"

# --- Install dependencies ---

install_mac() {
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  info "Installing packages via Homebrew..."
  brew install tmux neovim git
  brew install --cask ghostty
}

install_linux() {
  if command -v apt-get &>/dev/null; then
    info "Installing packages via apt..."
    sudo apt-get update
    sudo apt-get install -y tmux neovim git
  elif command -v dnf &>/dev/null; then
    info "Installing packages via dnf..."
    sudo dnf install -y tmux neovim git
  elif command -v pacman &>/dev/null; then
    info "Installing packages via pacman..."
    sudo pacman -Syu --noconfirm tmux neovim git
  else
    error "No supported package manager found (apt, dnf, pacman). Install tmux, neovim, and git manually."
    exit 1
  fi
}

if [[ "$OS" == "Darwin" ]]; then
  install_mac
else
  install_linux
fi

# --- Symlink configs ---

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    info "Removing existing symlink: $dest"
    rm "$dest"
  elif [ -e "$dest" ]; then
    warn "Backing up existing $dest to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  info "Linked $src -> $dest"
}

# Neovim
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Tmux
backup_and_link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Ghostty
backup_and_link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# --- TPM (Tmux Plugin Manager) ---

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  info "Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  info "TPM already installed."
fi

# --- Done ---

echo ""
info "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open tmux and press prefix + I to install tmux plugins"
echo "  2. Open nvim — Lazy will auto-install plugins on first launch"
