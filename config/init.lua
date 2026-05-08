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
	  "catppuccin/nvim", 
	  config = function()
		  require("catppuccin").setup({
			  flavour = "frappe"
		  })

		  vim.cmd.colorscheme "catppuccin"
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

  -- lsp {{{
  use
  {
	  'neovim/nvim-lspconfig'
  }

  use 
  {
  	"pmizio/typescript-tools.nvim",
  	requires = { "nvim-lua/plenary.nvim" },
  	config = function()
    	require("typescript-tools").setup ({
			settings = {
				expose_as_code_action = "all"
			},
		})
  	end,
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
--vim.cmd.colorscheme "catppuccin"

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
--
-- Define server configurations
vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
}

vim.lsp.config["terraformls"] = {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "tf", "hcl" },
}

vim.lsp.config["gopls"] = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

vim.lsp.config["yamlls"] = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  settings = {
    yaml = {
      -- Set to true to enable automatic schema downloading 
      schemaStore = {
        enable = false,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        -- You can manually pin schemas here if auto-detection fails
        -- ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
        -- ["kubernetes"] = "*.yaml",
      },
      format = { enable = false },
      validate = true,
      completion = true,
      hover = true,
    },
  },
}

-- Diagnostic Customization
vim.diagnostic.config({
  virtual_text = true,     -- Show message at end of line
  signs = true,            -- Show E/W/H in the gutter
  underline = true,        -- Underline the actual code
  update_in_insert = false, -- Don't yell at you while you're still typing
  severity_sort = true,
})

-- Enable language servers
vim.lsp.enable({ "lua_ls", "terraformls", "gopls", "yamlls" })
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
vim.keymap.set('n', '<leader>lr', "<cmd> Telescope lsp_references<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gs', "<cmd> Telescope git_status<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>of', "<cmd> Telescope oldfiles<CR>", { noremap = true, silent = true })
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
--Map a key to see the error message clearly
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
-- Jump between errors
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- Document symbols
vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol)
--
-- }}} 
--
-- COMMANDS {{{
--
-- Copy Relative buffer path
vim.api.nvim_create_user_command('CopyBuffer', function()
    vim.fn.setreg('+', vim.fn.expand('%')) end, {})
--
-- Copy Full buffer path
vim.api.nvim_create_user_command('CopyBufferFP', function()
    vim.fn.setreg('+', vim.fn.expand('%:p')) end, {})
--
-- }}}