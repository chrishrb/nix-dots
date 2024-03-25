local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	return
end

local icons = require "config.icons"

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
