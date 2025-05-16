local catppuccin = require("catppuccin")

catppuccin.setup({
	color_overrides = {
		all = {
			text = "#ffffff",
		},
		mocha = {
			base = "#1e1e2e",
		},
		frappe = {},
		macchiato = {},
		latte = {},
	},
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
