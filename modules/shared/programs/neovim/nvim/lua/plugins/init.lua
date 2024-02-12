local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, plugin = pcall(require, "lazy")
if not status_ok then return end

local plugins = {
  -----------------------------------------------------------------------------
  -- Look & feel
  -----------------------------------------------------------------------------
  {
    "catppuccin/nvim",
    config = function() require("plugins.config.colorscheme") end,
    lazy = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function() require("plugins.config.lualine") end,
    event = "VimEnter",
  },
  {
    "kdheepak/tabline.nvim",
    config = function() require("plugins.config.tabline") end,
    event = "VimEnter",
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons"
    },
    config = function() require("plugins.config.alpha") end,
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
    config = function() require("plugins.config.nvim-tree") end,
    event = "BufEnter",
  },

  {
    "folke/which-key.nvim",
    config = function() require("plugins.config.whichkey") end,
    cmd = "WhichKey",
    event = "VeryLazy",
  },

  -----------------------------------------------------------------------------
  -- LSP
  -----------------------------------------------------------------------------
  { -- language server installer
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",

      -- java and json language server
      "mfussenegger/nvim-jdtls",
      "tamago324/nlsp-settings.nvim",
      -- get documentation when pressing K
      "lewis6991/hover.nvim",
      -- for formatters and linters
      "jose-elias-alvarez/null-ls.nvim",
      -- winbar
      "SmiteshP/nvim-navic",
    },
  },
  {
    "lewis6991/hover.nvim",
    config = function() require("plugins.config.hover") end,
  },
  { -- show diagnostics of current document/workspace
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = true,
    event = "BufEnter",
  },

  -----------------------------------------------------------------------------
  -- DAP (Debugger)
  -----------------------------------------------------------------------------
  { -- debugging with nvim
    "mfussenegger/nvim-dap", -- debugger
    dependencies = {
      "rcarriga/nvim-dap-ui", -- ui for debugger
      "jayp0521/mason-nvim-dap.nvim", -- mason adapter for dap
      "theHamsta/nvim-dap-virtual-text", -- show line visual
    },
    config = function() require("plugins.config.dap") end,
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
      "L3MON4D3/LuaSnip", --snippet engine

      -- Misc
      "lukas-reineke/cmp-under-comparator", -- Tweak completion order
      "f3fora/cmp-spell",
    },
    config = function() require("plugins.config.cmp") end,
    event = "InsertEnter",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets", -- a bunch of snippets to
    },
    config = function () require("plugins.config.snippet") end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("plugins.config.copilot")
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("plugins.config.treesitter") end,
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    dependencies = {
      -- autoclose and rename html tags
      "windwp/nvim-ts-autotag",
    },
    event = "User FileOpened",
  },

  -----------------------------------------------------------------------------
  -- Telescope
  -----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    config = function() require("plugins.config.telescope") end,
    event = "BufEnter",
  },

  -----------------------------------------------------------------------------
  -- Syntax, Languages & Code
  -----------------------------------------------------------------------------
  { -- Autopairs, integrates with both cmp and treesitter
    "windwp/nvim-autopairs",
    config = true,
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
      require("plugins.config.indentline")
    end,
    main = "ibl",
    event = "VeryLazy",
  },

  { -- comment in/out with gc and gcc
    "terrortylor/nvim-comment",
    config = function() require("plugins.config.comment") end,
    event = "BufEnter",
  },

  -- rust tools
  { "simrat39/rust-tools.nvim" },

  -- go tools
  { "ray-x/go.nvim" },

  -----------------------------------------------------------------------------
  -- Git
  -----------------------------------------------------------------------------
  { -- show changed lines in vim
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.config.gitsigns") end,
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
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = false, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end,
    lazy = false,
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
  -- { -- use gx to go to link
  --   "tyru/open-browser.vim",
  --   event = "BufEnter",
  -- },
  { -- delete buffers without closing your window or messing up your layout
    "moll/vim-bbye",
    event = "VeryLazy",
  },
  { -- project management with  vim
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
    config = function() require("plugins.config.project") end,
  },
  { -- creates automatically missing directories, like mkdir -p
    "jghauser/mkdir.nvim",
    event = "BufEnter",
  },
  { -- disable certain features if opening big files
    "lunarvim/bigfile.nvim",
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },
  { -- disable certain features if opening big files
    dir = "~/jam-dev/home/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }} },
    cmd = { "Browse" },
    init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = true,
    -- config = function() require("gx").setup{
    --   handlers = {
    --     plugin = true,
    --   },
    -- } end,
  },
}

local opts = {
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  concurrency = 50,
  install = {
    missing = true, -- install missing plugins on startup.
    colorscheme = { "catppuccin" }, -- try to load one of these colorschemes when installation
  },
  ui = {
    size = {
      width = 0.7,
      height = 0.7
    },
  },
}

plugin.setup(plugins, opts)
