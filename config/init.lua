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
	  profile = "default",
	  files = {
		  -- use fd as the file finder and ignore node_modules and .git
		  fd_opts = "--color=never --type f --hidden --exclude node_modules --exclude .git --exclude package-lock.*"
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

  -- colorschemes {{{
  use 
  {
	  "loctvl842/monokai-pro.nvim",
	  config = function()
		  require("monokai-pro").setup()
	end
  }

  use 
  { 
	  "catppuccin/nvim", as = "catppuccin",
	  config = function()
		  require("catppuccin").setup({
			  flavour = "mocha"
		  })
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
	  ensure_installed = { "java", "lua", "typescript", "go", "yaml", "terraform" },
	  highlight = {
		  enable = true, -- Enable Treesitter-based highlighting
		  additional_vim_regex_highlighting = false,  -- Disable traditional highlighting
  	  },
  }
  -- }}}

  -- neovim lsp {{{
  use
  {
	  'neovim/nvim-lspconfig'
  }
 -- }}}
  
 -- startup.nvim {{{
  use 
  {
  	"startup-nvim/startup.nvim",
  	requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim"},
  	config = function()
    	require"startup".setup({
			theme = "dashboard",
			options = {
				mapping_keys = true,
			},
			mappings = {
				open_help ="?"
			},
		})
  	end
  }
 -- }}}

-- lualine.nvim {{{
  use 
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	 --config = function()
	--	require("lualine").setup()
	--end
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
--vim.cmd([[colorscheme monokai-pro]])
vim.cmd.colorscheme "catppuccin"

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

-- Do not add newline to EOF
vim.opt.fixendofline = false
vim.opt.endofline = false

-- LSP Config
vim.lsp.enable('gh_actions_ls')

-- }}}

-- KEY MAPS {{{
-- 
-- Key mapping: Ctrl+x Ctrl+j to convert keys to JSON-style quoted strings
vim.api.nvim_set_keymap("n", "<C-x><C-j>", [[:%s/[ \t]\([A-Za-z_].*\):/"\1":<CR>]], { noremap = true, silent = true })
--
-- Telescope {{{
--vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true })
-- }}} 
--
-- Toggle relative line numbers
vim.api.nvim_set_keymap('n', '<leader>l', ":set relativenumber!<CR>", { noremap = true, silent = true })
--
-- source lua and compile plugins on <leader>rl
vim.api.nvim_set_keymap('n', '<leader>rl', ':luafile ~/.config/nvim/init.lua\n:echo "Neovim config reloaded...syncing..."\n:PackerCompile<CR>', { noremap = true, silent = false })
--
-- Floating terminal
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>ToggleTerm<CR>', { noremap = true, silent = true })
--
-- Smart Startup.nvim autocommand {{{
vim.api.nvim_create_autocmd("TabNewEntered", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local line_count = vim.api.nvim_buf_line_count(0)
    local is_empty = (bufname == "" and line_count <= 1)

    if is_empty then
      pcall(function()
        require("startup").setup(require("startup").config)
      end)
    end
  end,
})

-- }}}
--
-- }}}