local catppuccin = require("catppuccin")
local theme = nixCats("theme")

catppuccin.setup({
	flavour = theme, -- latte, frappe, macchiato, mocha
})

vim.opt.fillchars = {
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┫",
	vertright = "┣",
	verthoriz = "╋",
}

vim.cmd.colorscheme("catppuccin")
