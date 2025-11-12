## Neovim Configuration Setup

### Installation

You can install Neovim via the `nvim-upgrade.sh` script.  
It will install the **current pre-release build** (`v0.12.0-dev`).

```
bash
./nvim-upgrade.sh
```

### Plugin Setup

1. Install `packer.nvim`:
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

2. Install Plugins
```
cd path/to/init.lua
nvim init.lua

# From within neovim
:PackerInstall

# Reload init.lua
:source ~/path/to/init.lua
```

### Plugin Overview
```
fzf-lua
A blazing fast fuzzy finder written in Lua.
https://github.com/ibhagwan/fzf-lua
```

```
toggleterm.nvim
A modern terminal manager for Neovim that opens floating terminals.
https://github.com/akinsho/toggleterm.nvim
```

```
Colorschemes
Two color themes are available out of the box:

monokai-pro.nvim
A vibrant Monokai Pro theme for Neovim.
https://github.com/loctvl842/monokai-pro.nvim

catppuccin/nvim
A soft pastel theme.
https://github.com/catppuccin/nvim
```

```
nvim-treesitter
Provides advanced syntax highlighting and code parsing based on Treesitter.
Installed parsers: java, lua, typescript, go, yaml, terraform
https://github.com/nvim-treesitter/nvim-treesitter
```

```
nvim-lspconfig
Simplifies the setup of Neovim’s built-in LSP (Language Server Protocol) clients.
https://github.com/neovim/nvim-lspconfig
```

```
startup.nvim
A customizable Neovim startup dashboard.
Theme: dashboard
https://github.com/max397574/startup.nvim
```

### Core editor configuration

| Feature      | Setting                                 |
| ------------ | --------------------------------------- |
| Leader key   | `<Space>`                               |
| Line numbers | Absolute + relative                     |
| Tab width    | 4 spaces                                |
| Indentation  | Smart autoindent                        |
| Colorscheme  | `catppuccin`                            |
| EOF behavior | No trailing newline automatically added |

### Key Mappings

| Mapping            | Mode            | Description                                |
| ------------------ | --------------- | ------------------------------------------ |
| `<Ctrl+x><Ctrl+j>` | Normal          | Convert keys to JSON-style quoted strings  |
| `<leader>ff`       | Normal          | Find files (Telescope)                     |
| `<leader>fg`       | Normal          | Live grep (Telescope)                      |
| `<leader>fb`       | Normal          | Show open buffers (Telescope)              |
| `<leader>l`        | Normal          | Toggle relative line numbers               |
| `<leader>rl`       | Normal          | Reload Neovim config and recompile plugins |
| `<leader>t`        | Normal          | Toggle floating terminal                   |
| `<Ctrl+\\>`        | Normal/Terminal | Toggle terminal (via toggleterm)           |
