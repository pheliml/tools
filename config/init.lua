-- init.lua
-- zM close all folds
-- zR open all folds
-- zc/zo open/close fold under cursor

-- Load packer
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself

-- PLUGINS {{{
--
  -- fuzzy finder written in lua {{{
  use 
  {
	  'ibhagwan/fzf-lua',
	  requires = { 'nvim-tree/nvim-web-devicons' }
  }
  require('fzf-lua').setup
  {
	  files = {
		  -- Use fd as the file finder and ignore node_modules and .git
		  fd_opts = "--color=never --type f --hidden --exclude node_modules --exclude .git"
	  }
  }
  -- }}}

  -- enable floating terminal in nvim {{{
  use 
  {
	  "akinsho/toggleterm.nvim", tag = '*', config = function()
		  require("toggleterm").setup
		  {
			  size = 20,
			  open_mapping = [[<c-\>]], -- Ctrl+\ to toggle terminal
    		  shading_factor = 2,
    		  direction = 'float', -- makes the terminal float
    		  float_opts = { border = 'curved' }
  		  }
    end
  }
  -- }}}

  -- monokai-pro colorscheme {{{
  use 
  {
	  "loctvl842/monokai-pro.nvim",
	  config = function()
		  require("monokai-pro").setup()
	end
  }
  -- }}}

  -- treesitter for advanced syntax highlighting {{{
  use 
  {
	  'nvim-treesitter/nvim-treesitter',
	  run = ':TSUpdate'
  }
  require'nvim-treesitter.configs'.setup 
  {
	  ensure_installed = { "java", "lua", "typescript", "go" },
	  highlight = {
		  enable = true, -- Enable Treesitter-based highlighting
		  additional_vim_regex_highlighting = false,  -- Disable traditional highlighting
  	  },
  }
  -- }}}

  end
)
-- }}}

-- CORE EDITOR CONFIG {{{
--
-- Disable compatibility with old vi
vim.opt.compatible = false

-- map leader key to " "
vim.g.mapleader = ' '

 --Enable syntax highlighting
vim.cmd("syntax on")

-- Set color scheme
vim.cmd([[colorscheme monokai-pro]])

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

-- Fold marker
vim.opt.foldenable = true
vim.opt.foldlevel = 0
vim.opt.foldmethod = "marker"

-- }}}

-- KEY MAPS {{{
-- 
-- Key mapping: Ctrl+x Ctrl+j to convert keys to JSON-style quoted strings
vim.api.nvim_set_keymap("n", "<C-x><C-j>", [[:%s/[ \t]\([A-Za-z_].*\):/"\1":<CR>]], { noremap = true, silent = true })
-- Format JSON with jq (whole buffer)
vim.keymap.set('n', '<leader>q', '<Cmd> %!jq .<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })

-- source lua on space rl
vim.api.nvim_set_keymap('n', '<leader>rl', ':luafile ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>ToggleTerm<CR>', { noremap = true, silent = true })

-- }}}
