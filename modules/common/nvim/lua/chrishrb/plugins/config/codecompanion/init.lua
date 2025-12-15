local codecompanion = require("codecompanion")
local icons = require("chrishrb.config.icons")

local adapter = nixCats("aiProvider")
local model = nixCats("aiModel")

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
	prompt_library = require("chrishrb.plugins.config.codecompanion.prompts"),
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				show_server_tools_in_chat = false,
			},
		},
		history = {
			enabled = true,
		},
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
			adapter = {
				name = adapter,
				model = model,
			},
			tools = {
				groups = groups,
			},
		},
		inline = {
			adapter = {
				name = adapter,
				model = model,
			},
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
			adapter = {
				name = adapter,
				model = model,
			},
			tools = {
				groups = groups,
			},
		},
	},
	memory = {
		spec = {
			description = "Short term memory for agent plans",
			parser = "claude",
			files = {
				".spec.md",
			},
		},
		opts = {
			chat = {
				enabled = true,
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
