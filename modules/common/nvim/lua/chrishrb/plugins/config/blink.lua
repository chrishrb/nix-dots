local icons = require("chrishrb.config.icons")

local providers = {
	lsp = {
		name = "LSP",
		module = "blink.cmp.sources.lsp",
	},
	buffer = {
		name = "Buffer",
		module = "blink.cmp.sources.buffer",
	},
	path = {
		name = "Path",
		module = "blink.cmp.sources.path",
	},
}

require("blink.cmp").setup({
	keymap = {
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<C-Space>"] = { "show" },
		["<C-e>"] = { "cancel", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	cmdline = {
		keymap = {
			preset = "inherit",

			["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
			["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
		},
		completion = { menu = { auto_show = false } },
	},
	completion = {
		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
				components = {
					kind_icon = {
						text = function(ctx)
							return (icons.kind[ctx.kind] or icons.kind.Fallback) .. " "
						end,
					},
					source_name = {
						text = function(ctx)
							local labels = {
								LSP = "[LSP]",
								Buffer = "[Buffer]",
								Path = "[Path]",
							}
							return labels[ctx.source_name] or ("[" .. ctx.source_name .. "]")
						end,
					},
				},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,
			window = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			},
		},
	},
	sources = {
		default = sources_default,
		providers = providers,
	},
})
