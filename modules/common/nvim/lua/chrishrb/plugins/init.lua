local status_ok, nixCatsUtils = pcall(require, "nixCatsUtils")
if not status_ok then
	return
end

local status_ok_lazy_cat, lazyCat = pcall(require, "nixCatsUtils.lazyCat")
if not status_ok_lazy_cat then
	return
end

if not nixCatsUtils.isNixCats then
	print("ERROR: Not supported at the moment")
	return
end

local plugins = {
	-----------------------------------------------------------------------------
	-- Look & feel
	-----------------------------------------------------------------------------
	{
		"catppuccin/nvim",
		config = function()
			require("chrishrb.plugins.config.colorscheme")
		end,
		name = "catppuccin-nvim",
		lazy = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("chrishrb.plugins.config.lualine")
		end,
		event = "VimEnter",
	},
	{
		"kdheepak/tabline.nvim",
		config = function()
			require("chrishrb.plugins.config.tabline")
		end,
		event = "VimEnter",
	},
	-- Icons for nvim-tree
	{ "kyazdani42/nvim-web-devicons" },

	-----------------------------------------------------------------------------
	-- Navigation
	-----------------------------------------------------------------------------
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("chrishrb.plugins.config.nvim-tree")
		end,
		event = "BufEnter",
	},

	{
		"folke/which-key.nvim",
		config = function()
			require("chrishrb.plugins.config.whichkey")
		end,
		cmd = "WhichKey",
		event = "VeryLazy",
	},

	-----------------------------------------------------------------------------
	-- LSP
	-----------------------------------------------------------------------------
	{ -- language server installer
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				enabled = nixCatsUtils.lazyAdd(true, false),
			},
			{
				"williamboman/mason-lspconfig.nvim",
				enabled = nixCatsUtils.lazyAdd(true, false),
			},
			-- java and json language server
			{
				"mfussenegger/nvim-jdtls",
				enabled = nixCats("java"),
			},
			-- get documentation when pressing K
			{
				"lewis6991/hover.nvim",
				config = function()
					require("chrishrb.plugins.config.hover")
				end,
			},
			-- for formatters and linters
			{
				"nvimtools/none-ls.nvim",
				dependencies = {
					"nvimtools/none-ls-extras.nvim",
				},
			},
		},
	},
	{ -- show diagnostics of current document/workspace
		"folke/trouble.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		config = true,
		event = "BufEnter",
	},
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
		enabled = nixCats("flutter"),
	},

	-----------------------------------------------------------------------------
	-- DAP (Debugger)
	-----------------------------------------------------------------------------
	{ -- debugging with nvim
		"rcarriga/nvim-dap-ui", -- ui for debugger
		dependencies = {
			"mfussenegger/nvim-dap", -- debugger
			"nvim-neotest/nvim-nio", -- important for dapui
			"theHamsta/nvim-dap-virtual-text", -- show line visual
			{
				"leoluz/nvim-dap-go", -- debugger for go
				enabled = nixCats("go"),
			},
			{
				"mfussenegger/nvim-dap-python", -- debugger for python
				enabled = nixCats("python"),
			},
		},
		config = function()
			require("chrishrb.plugins.config.dap")
		end,
		enabled = nixCats("debug"),
	},

	-----------------------------------------------------------------------------
	-- Testing
	-----------------------------------------------------------------------------
	{ -- test with nvim
		"vim-test/vim-test",
		dependencies = {
			"preservim/vimux", -- run test in tmux pane below
		},
	},

	-----------------------------------------------------------------------------
	-- Completions
	-----------------------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			"hrsh7th/cmp-cmdline", -- Cmdline completions
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"hrsh7th/cmp-nvim-lsp-document-symbol", -- For textDocument/documentSymbol

			-- Snippets
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			{
				"L3MON4D3/LuaSnip", --snippet engine
				name = "luasnip",
				config = function()
					require("chrishrb.plugins.config.snippet")
				end,
			},
			"rafamadriz/friendly-snippets", -- a bunch of snippets to

			-- Misc
			"petertriho/cmp-git", -- git source
			{ -- copilot
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup()
				end,
			},
			"hrsh7th/cmp-emoji", -- emoji
		},
		config = function()
			require("chrishrb.plugins.config.cmp")
		end,
		event = "InsertEnter",
	},

	-----------------------------------------------------------------------------
	-- Treesitter
	-----------------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = nixCatsUtils.lazyAdd(":TSUpdate"),
		config = function()
			require("chrishrb.plugins.config.treesitter")
		end,
		dependencies = {
			-- autoclose and rename html tags
			"windwp/nvim-ts-autotag",
		},
	},
	{
		"towolf/vim-helm",
		ft = "helm",
	},

	-----------------------------------------------------------------------------
	-- Telescope
	-----------------------------------------------------------------------------
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("chrishrb.plugins.config.telescope")
		end,
		event = "BufEnter",
	},

	-----------------------------------------------------------------------------
	-- Syntax, Languages & Code
	-----------------------------------------------------------------------------
	{ -- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
		config = function()
			require("chrishrb.plugins.config.autopairs")
		end,
		event = "InsertEnter",
	},
	{ -- change surround e.g. ys{motion}{char}, ds{char}, cs{target}{replacement}
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to `main` branch for the latest features
		event = "BufEnter",
		config = true,
	},
	{ -- indent line
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("chrishrb.plugins.config.indentline")
		end,
		main = "ibl",
		event = "VeryLazy",
	},

	{ -- comment in/out with gc and gcc
		"terrortylor/nvim-comment",
		config = function()
			require("chrishrb.plugins.config.comment")
		end,
		event = "BufEnter",
	},

	-- rust tools
	-- { "simrat39/rust-tools.nvim" },

	-----------------------------------------------------------------------------
	-- Git
	-----------------------------------------------------------------------------
	{ -- show changed lines in vim
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("chrishrb.plugins.config.gitsigns")
		end,
		event = "BufReadPre",
	},
	{ -- basic git
		"tpope/vim-fugitive",
		cmd = "Git",
		event = "VeryLazy",
	},

	-----------------------------------------------------------------------------
	-- Tmux
	-----------------------------------------------------------------------------
	{ -- tmux navigation
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = false, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				},
			})
		end,
		lazy = false,
	},

	-----------------------------------------------------------------------------
	-- AI
	-----------------------------------------------------------------------------
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
			"echasnovski/mini.diff",
			"ravitemer/codecompanion-history.nvim",
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				config = function()
					require("copilot").setup({
						suggestion = { enabled = false },
						panel = { enabled = false },
						filetypes = {
							yaml = true,
							["."] = true,
						},
					})
				end,
			},
			{
				"stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
				opts = {},
			},
			"nvim-telescope/telescope.nvim", -- Optional: For using slash commands
			{
				"ravitemer/mcphub.nvim",
				name = "mcphub.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				-- cmd = "MCPHub",  -- lazy load
				config = function()
					require("chrishrb.plugins.config.mcphub")
				end,
			},
		},
		config = function()
			require("chrishrb.plugins.config.codecompanion")
		end,
	},

	-----------------------------------------------------------------------------
	-- Misc
	-----------------------------------------------------------------------------
	-- Useful lua functions used in lots of plugins
	{ "nvim-lua/plenary.nvim" },
	{ -- delete all bufs except the one you are working
		"vim-scripts/BufOnly.vim",
		event = "BufEnter",
	},
	{ -- delete buffers without closing your window or messing up your layout
		"moll/vim-bbye",
		event = "VeryLazy",
	},
	{ -- project management with  vim
		"ahmedkhalf/project.nvim",
		event = "VimEnter",
		config = function()
			require("chrishrb.plugins.config.project")
		end,
	},
	{ -- creates automatically missing directories, like mkdir -p
		"jghauser/mkdir.nvim",
		event = "BufEnter",
	},
	{ -- disable certain features if opening big files
		"lunarvim/bigfile.nvim",
		event = { "FileReadPre", "BufReadPre", "User FileOpened" },
	},
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		config = true,
	},
}

local opts = {
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	rocks = { enabled = false },
}

lazyCat.setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), plugins, opts)
