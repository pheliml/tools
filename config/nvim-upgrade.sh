#!/bin/bash

#v0.12.0-dev

set -euo pipefail

tmp=$(mktemp)
curl -L https://github.com/neovim/neovim/releases/download/v0.12.0/nvim-linux-x86_64.appimage -o "$tmp"
chmod +x "$tmp"
sudo install -Dm755 "$tmp" /usr/local/bin/nvim
echo "Neovim installed at /usr/local/bin/nvim → $(nvim --version | head -1)"

