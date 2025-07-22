local git_conflict = require("git-conflict")

git_conflict.setup({
  default_mappings = false, -- disable the default mappings
})

local which_key = require("which-key")
which_key.add({
	{
		{ "<leader>gc", group = "Conflict", nowait = true, remap = false },
		{
			"<leader>gco",
			"<Plug>(git-conflict-ours)",
			desc = "Choose ours",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gct",
			"<Plug>(git-conflict-theirs)",
			desc = "Choose theirs",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gcb",
			"<Plug>(git-conflict-both)",
			desc = "Choose both",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gc0",
			"<Plug>(git-conflict-none)",
			desc = "Choose none",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gcl",
			"<cmd>GitConflictListQf<cr>",
			desc = "Conflict list",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gcr",
			"<cmd>GitConflictRefresh<cr>",
			desc = "Refresh conflicts",
			nowait = true,
			remap = false,
		},

		{
			"[x",
			"<Plug>(git-conflict-prev-conflict)",
			desc = "Previous conflict",
			nowait = true,
			remap = false,
		},
		{
			"]x",
			"<Plug>(git-conflict-next-conflict)",
			desc = "Next conflict",
			nowait = true,
			remap = false,
		},
	},
})
