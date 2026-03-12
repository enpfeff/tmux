#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_INSTALL_DIR="${HOME}/.local/bin"
TMUX_CONFIG_DIR="${HOME}/.config/tmux"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check for fzf
if ! command -v fzf &> /dev/null; then
    warn "fzf is not installed or not on PATH!"
    warn "tmux-session.sh requires fzf to work properly."
    warn "Install fzf: https://github.com/junegunn/fzf#installation"
fi

# Create bin install directory if it doesn't exist
if [[ ! -d "$BIN_INSTALL_DIR" ]]; then
    info "Creating $BIN_INSTALL_DIR..."
    mkdir -p "$BIN_INSTALL_DIR"
fi

# Check if BIN_INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":$BIN_INSTALL_DIR:"* ]]; then
    warn "$BIN_INSTALL_DIR is not in your PATH!"
    warn "Add the following to your shell rc file:"
    warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# Install scripts from bin directory
info "Installing scripts from bin/ to $BIN_INSTALL_DIR..."
for script in "$SCRIPT_DIR/bin/"*; do
    if [[ -f "$script" ]]; then
        script_name=$(basename "$script")
        # Remove .sh extension for cleaner command names
        install_name="${script_name%.sh}"
        cp "$script" "$BIN_INSTALL_DIR/$install_name"
        chmod +x "$BIN_INSTALL_DIR/$install_name"
        info "  Installed: $install_name"
    fi
done

# Create tmux config directory if it doesn't exist
if [[ ! -d "$TMUX_CONFIG_DIR" ]]; then
    info "Creating $TMUX_CONFIG_DIR..."
    mkdir -p "$TMUX_CONFIG_DIR"
fi

# Copy tmux configuration
info "Installing tmux.conf to $TMUX_CONFIG_DIR/tmux.conf..."
cp "$SCRIPT_DIR/tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"

info "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Make sure $BIN_INSTALL_DIR is in your PATH"
echo "  2. Install TPM (Tmux Plugin Manager) if not already installed:"
echo "     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
echo "  3. Start tmux and press prefix + I to install plugins"

