local hover = require("hover")

hover.config({
	providers = {
		"hover.providers.diagnostic",
		"hover.providers.lsp",
		"hover.providers.dap",
		"hover.providers.man",
		"hover.providers.gh",
		"hover.providers.gh_user",
		-- 'hover.providers.jira',
		-- 'hover.providers.fold_preview',
		-- 'hover.providers.highlight',
	},
	preview_opts = {
		border = nil,
	},
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = false,
	title = true,
})

-- Setup keymaps
vim.keymap.set("n", "K", hover.open, { desc = "hover.nvim" })
vim.keymap.set("n", "gK", hover.enter, { desc = "hover.nvim (enter)" })
