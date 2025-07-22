local which_key = require("which-key")

local M = {}

local icons = require("chrishrb.config.icons")

local setup = {
	preset = "modern",
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 30, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	icons = {
		breadcrumb = icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
		separator = icons.ui.BoldArrowRight, -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
		mappings = false,
	},
	win = {
		border = "rounded", -- none, single, double, shadow
	},
	layout = {
		height = { min = 2, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	filter = function(mapping)
		-- example to exclude mappings without a description
		-- return mapping.desc and mapping.desc ~= ""
		return true
	end,
	show_help = true, -- show help message on the command line when the popup is visible
}
which_key.setup(setup)

which_key.add({
	-- General
	{ "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text", nowait = true, remap = false },
	{
		"<leader>P",
		"<cmd>lua require('telescope').extensions.projects.projects()<cr>",
		desc = "Projects",
		nowait = true,
		remap = false,
	},
	{ "<leader>b", "<cmd>Buffers<cr>", desc = "Buffers", nowait = true, remap = false },
	{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", nowait = true, remap = false },
	{
		"<leader>f",
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{hidden = true, previewer = false})<cr>",
		desc = "Find files",
		nowait = true,
		remap = false,
	},
	{
		"<leader>h",
		"<cmd>nohlsearch<CR>",
		desc = "No Highlight",
		nowait = true,
		remap = false,
	},
	{ "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Previous Diagnostic" },
	{ "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },

	-- Hidden
	{
		"<leader>r",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		desc = "Rename variable",
		nowait = true,
		remap = false,
		hidden = true,
	},
	{
		"<leader>n",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		desc = "Codeaction",
		nowait = true,
		remap = false,
		hidden = true,
	},

	-- Git
	{
		{ "<leader>g", group = "Git", nowait = true, remap = false },
		{
			"<leader>gR",
			"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
			desc = "Reset Buffer",
			nowait = true,
			remap = false,
		},
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", nowait = true, remap = false },
		{ "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Diff", nowait = true, remap = false },
		{
			"[g",
			"<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
			desc = "Prev Hunk",
			nowait = true,
			remap = false,
		},
		{
			"]g",
			"<cmd>lua require 'gitsigns'.next_hunk()<cr>",
			desc = "Next Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gl",
			"<cmd>lua require 'gitsigns'.blame_line()<cr>",
			desc = "Blame",
			nowait = true,
			remap = false,
		},
		{
			"<leader>go",
			"<cmd>Telescope git_status<cr>",
			desc = "Open changed file",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gp",
			"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
			desc = "Preview Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gr",
			"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
			desc = "Reset Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gs",
			"<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
			desc = "Stage Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gu",
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			desc = "Undo Stage Hunk",
			nowait = true,
			remap = false,
		},
		{ "<leader>gL", "<cmd>GcLog %<cr>", desc = "History of current file", nowait = true, remap = false },
	},

	-- LSP
	{
		{ "<leader>l", group = "LSP", nowait = true, remap = false },
		{
			"<leader>ld",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
			nowait = true,
			remap = false,
		},
		{
			"<leader>lf",
			"<cmd>lua vim.lsp.buf.formatting()<cr>",
			desc = "Format",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ll",
			"<cmd>lua vim.lsp.codelens.run()<cr>",
			desc = "CodeLens Action",
			nowait = true,
			remap = false,
		},
		{
			"<leader>lr",
			"<cmd>Trouble lsp toggle<cr>",
			desc = "LSP Definitions / Refences / ... (Trouble)",
			nowait = true,
			remap = false,
		},
		{
			"<leader>lq",
			"<cmd>Trouble quickfix list<cr>",
			desc = "Qucikfix List (Trouble)",
			nowait = true,
			remap = false,
		},
	},

	-- Search
	{
		{ "<leader>s", group = "Search", nowait = true, remap = false },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
		{ "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
		{ "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help", nowait = true, remap = false },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
		{ "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File", nowait = true, remap = false },
	},

	-- Testing
	{
		{ "<leader>t", group = "Testing", nowait = true, remap = false },
		{ "<leader>tn", "<cmd>TestNearest<cr>", desc = "Test nearest", nowait = true, remap = false },
		{ "<leader>tf", "<cmd>TestFile<cr>", desc = "Test file", nowait = true, remap = false },
		{ "<leader>ta", "<cmd>TestSuite<cr>", desc = "Test all", nowait = true, remap = false },
	},

	-- git diff
	{ "gdh", "<cmd>diffget //2<cr>", desc = "Get diff left", nowait = true, remap = false },
	{ "gdl", "<cmd>diffget //3<cr>", desc = "Get diff right", nowait = true, remap = false },
})

return M
