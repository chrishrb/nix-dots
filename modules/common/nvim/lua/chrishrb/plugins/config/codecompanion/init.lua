local codecompanion = require("codecompanion")
local icons = require("chrishrb.config.icons")

require("dressing").setup({
	input = {
		enabled = false,
	},
	select = {
		enabled = true,
	},
})

codecompanion.setup({
	prompt_library = {
		markdown = {
			dirs = {
				nixCats.configDir .. "/prompts",
			},
		},
	},
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
			opts = {
				show_preset_actions = false, -- Show the preset actions in the action palette?
				show_preset_prompts = false, -- Show the preset prompts in the action palette?
				show_preset_rules = false, -- Show the preset rules in the action palette?
			},
		},
		chat = {
			intro_message = "",
			start_in_insert_mode = false,
		},
	},
	interactions = {
		chat = {
			adapter = {
				name = "copilot",
				model = "claude-sonnet-4.5",
			},
			slash_commands = {
				["image"] = {
					opts = {
						dirs = { "~/screenshots" },
					},
				},
			},
		},
		inline = {
			adapter = {
				name = "copilot",
				model = "gpt-4.1",
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
	},
	background = {
		chat = {
			opts = {
				enabled = true,
			},
		},
	},
	opts = {
		adapters = {
			http = {
				opts = {
					show_presets = false,
					show_model_choices = true,
				},
				copilot = "copilot",
			},
		},
		log_level = "ERROR",
		send_code = true,
		system_prompt = require("chrishrb.plugins.config.codecompanion.system_prompt"),
	},
})

-- setup which-key mappings
require("chrishrb.plugins.config.codecompanion.key-mappings")
