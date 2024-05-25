local indent_blankline = require("ibl")
local icons = require "chrishrb.config.icons"

indent_blankline.setup {
  exclude = {
    buftypes = { "terminal", "nofile" },
    filetypes = {
      "help",
      "startify",
      "dashboard",
      "lazy",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "text",
    },
  },
  indent = {
    char = icons.ui.LineLeft,
  },
  scope = {
    enabled = false,
  }
}
