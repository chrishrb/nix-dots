local codecompanion = require("codecompanion")
local context_utils = require("codecompanion.utils.context")
local icons = require("chrishrb.config.icons")
local api = vim.api

local which_key = require("which-key")
which_key.add({
	{
    -- Normal mode mappings
		{ "<leader>c", group = "CodeCompanion", nowait = true, remap = false },
		{
			"<leader>cc",
			function()
				local input = vim.fn.input(icons.ui.AiPrefix)
				if input ~= "" then
					codecompanion.chat({ fargs = { "chat" }, args = input, range = 0 })
				end
			end,
			desc = "Quick chat",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ci",
			"<cmd>CodeCompanion<CR>",
			desc = "Inline chat",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ca",
			"<cmd>CodeCompanionActions<CR>",
			desc = "Actions",
			nowait = true,
			remap = false,
		},
		{
			"<leader>co",
			"<cmd>CodeCompanionChat<CR>",
			desc = "New Chat",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ct",
			"<cmd>CodeCompanionChat Toggle<CR>",
			desc = "Toggle chat",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ch",
			"<cmd>CodeCompanionHistory<CR>",
			desc = "History",
			nowait = true,
			remap = false,
		},

    -- Visual mode mappings
		{
			mode = { "v" },
			{ "<leader>c", group = "CodeCompanion", nowait = true, remap = false },
			{
				"<leader>cc",
				function()
					local input = vim.fn.input(icons.ui.AiPrefix)
					if input ~= "" then
						local context = context_utils.get(api.nvim_get_current_buf(), {})
						local content = input .. "\n\nHere is the code from " .. context.filename .. ":\n\n"
						codecompanion.chat({ fargs = { "chat" }, args = content, range = 1 })
					end
				end,
				desc = "Chat with selection",
				nowait = true,
				remap = false,
			},
			{
				"<leader>ca",
				":CodeCompanionActions<CR>",
				desc = "Actions",
				nowait = true,
				remap = false,
			},
		},
	},
})

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
