local telescope = require("telescope")
local actions = require("telescope.actions")
local icons = require("chrishrb.config.icons")

-- workaround for https://github.com/nvim-treesitter/nvim-treesitter/issues/7952
local open_after_tree = function(prompt_bufnr)
	vim.defer_fn(function()
		actions.select_default(prompt_bufnr)
	end, 100) -- Delay allows filetype and plugins to settle before opening
end

telescope.setup({
	defaults = {

		prompt_prefix = icons.ui.Telescope,
		selection_caret = icons.ui.ChevronRight,
		path_display = { "smart" },

		mappings = {
			i = {
				["<esc>"] = actions.close, -- exit on first <esc>
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>

				["<CR>"] = open_after_tree,
			},
			n = { ["<CR>"] = open_after_tree },
		},
		vimgrep_arguments = {
			"rg",
			"--vimgrep",
			"--hidden",
			"--smart-case",
			"--trim",
		},
		file_ignore_patterns = {
			"node_modules",
			".git/",
			".cache",
			"%.o",
			"%.a",
			"%.out",
			"%.class",
			"%.pdf",
			"%.mkv",
			"%.mp4",
			"%.zip",
		},
	},
	pickers = {
		buffers = {
			theme = "ivy",
			mappings = {
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
			},
		},
	},
})
