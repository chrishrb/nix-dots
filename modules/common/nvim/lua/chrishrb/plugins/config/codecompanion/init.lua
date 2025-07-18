local codecompanion = require("codecompanion")
local icons = require("chrishrb.config.icons")

local adapter = "copilot"

require("dressing").setup({
	input = {
		enabled = false,
	},
	select = {
		enabled = true,
	},
})

local groups = {
	["agent"] = {
		description = "Agentic Dev Workflow",
		system_prompt = "You are a developer with access to various tools.",
		tools = {
			"cmd_runner",
			"editor",
			"files",
			"mcp",
		},
	},
}

codecompanion.setup({
	-- prompt_library = require("chrishrb.plugins.config.codecompanion.prompts"),
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
				make_vars = true, -- make chat #variables from MCP server resources
				make_slash_commands = true, -- make /slash_commands from MCP server prompts
			},
		},
		history = {
			enabled = true,
		},
	},
	adapters = {
		copilot = function()
			return require("codecompanion.adapters").extend("copilot", {
				schema = {
					model = {
						default = "claude-3.7-sonnet",
					},
				},
			})
		end,
	},
	display = {
		action_palette = {
			prompt = icons.ui.AiPrefix,
			opts = {
				show_default_actions = true,
				show_default_prompt_library = true,
			},
		},
		chat = {
			intro_message = "",
			start_in_insert_mode = false,
		},
	},
	strategies = {
		chat = {
			adapter = adapter,
			tools = {
				groups = groups,
			},
		},
		inline = {
			adapter = adapter,
			tools = {
				groups = groups,
			},
			keymaps = {
				accept_change = {
					modes = { n = "ga" },
					description = "Accept the suggested change",
				},
				reject_change = {
					modes = { n = "gr" },
					description = "Reject the suggested change",
				},
			},
		},
		cmd = {
			adapter = adapter,
			tools = {
				groups = groups,
			},
		},
	},
	opts = {
		log_level = "ERROR",
		send_code = true,
		system_prompt = require("chrishrb.plugins.config.codecompanion.system_prompt"),
	},
})

-- setup which-key mappings
require("chrishrb.plugins.config.codecompanion.key-mappings")
