local tabline = require("tabline")
local icons = require("chrishrb.config.icons")

tabline.setup({
	-- Defaults configuration options
	enable = true,
	options = {
		-- If lualine is installed tabline will use separators configured in lualine by default.
		-- These options can be used to override those settings.
		component_separators = { icons.ui.IndentLine, icons.ui.IndentLine },
		section_separators = { icons.ui.HalfCircleRight, icons.ui.HalfCircleLeft },
		max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
		show_tabs_always = true, -- this shows tabs only when there are more than one tab or if the first tab is named
		show_devicons = true, -- this shows devicons in buffer section
		colored = true,
		show_bufnr = false, -- this appends [bufnr] to buffer section,
		tabline_show_last_separator = true,
		show_filename_only = true, -- shows base filename only instead of relative path in filename
		modified_icon = "+ ", -- change the default modified icon
		modified_italic = true, -- set to true by default; this determines whether the filename turns italic if modified
		show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
	},
})
vim.cmd([[
  set guioptions-=e " Use showtabline in gui vim
  set sessionoptions+=tabpages,globals " store tabpages and globals in session
]])
