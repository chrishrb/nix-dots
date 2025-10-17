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
			"vectorcode",
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
		vectorcode = {
			opts = {
				tool_group = {
					enabled = true,
					extras = {},
					collapse = false,
				},
				tool_opts = {
					["*"] = {},
					ls = {},
					vectorise = {},
					query = {
						max_num = { chunk = -1, document = -1 },
						default_num = { chunk = 50, document = 10 },
						include_stderr = false,
						use_lsp = false,
						no_duplicate = true,
						chunk_mode = false,
						summarise = {
							enabled = false,
							adapter = nil,
							query_augmented = true,
						},
					},
					files_ls = {},
					files_rm = {},
				},
			},
		},
	},
	adapters = {
		http = {
			[adapter] = function()
				return require("codecompanion.adapters").extend(adapter, {
					schema = {
						model = {
							default = model,
						},
					},
				})
			end,
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
