-- Load packer (required)
vim.cmd [[packadd packer.nvim]]

-- Use packer to manage plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'       -- Packer manages itself

  -- Add plugins here, for example:
  use {
    'ibhagwan/fzf-lua',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
end)

-- Disable compatibility with old vi
vim.opt.compatible = false

-- map leader to " "
vim.g.mapleader = ' '

 --Enable syntax highlighting
vim.cmd("syntax on")

-- Set color scheme and background
vim.opt.background = "dark"
vim.cmd("colorscheme unokai")

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Viminfo options
vim.opt.viminfo = "'100,<500,s10,h"

-- Tabs and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Key mapping: Ctrl+x Ctrl+j to convert keys to JSON-style quoted strings
vim.api.nvim_set_keymap("n", "<C-x><C-j>", [[:%s/[ \t]\([A-Za-z_].*\):/"\1":<CR>]], { noremap = true, silent = true })

require('fzf-lua').setup({
  files = {
    -- Use fd as the file finder and ignore node_modules and .git
    fd_opts = "--color=never --type f --hidden --exclude node_modules --exclude .git"
  }
})

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })

-- source lua on \
vim.api.nvim_set_keymap('n', '<leader>r', ':luafile ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })

