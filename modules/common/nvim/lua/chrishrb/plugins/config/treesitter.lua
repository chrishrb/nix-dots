vim.defer_fn(function()
  local configs = require("nvim-treesitter.configs")

  configs.setup {
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    autopairs = {
      enable = true,
    },
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { }, -- list of language that will be disabled
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "yaml", "python", "java", "terraform" } },
    context_commentstring = {
      enable = true,
    },
    autotag = {
      enable = true
    }
  }
end, 0)
