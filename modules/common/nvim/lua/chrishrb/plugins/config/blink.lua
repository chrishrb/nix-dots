local icons = require("chrishrb.config.icons")

local has_minuet, minuet = pcall(require, "minuet")

local sources_default = { "lsp", "buffer", "path" }
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

if has_minuet then
	providers.ai = {
		name = "AI",
		module = "minuet.blink",
		async = true,
		timeout_ms = 3000,
		score_offset = 50,
	}

	table.insert(sources_default, 1, "ai")

	minuet.setup({
		provider = "openai_fim_compatible",
		n_completions = 1, -- recommend for local model for resource saving
		-- I recommend beginning with a small context window size and incrementally
		-- expanding it, depending on your local computing power. A context window
		-- of 512, serves as an good starting point to estimate your computing
		-- power. Once you have a reliable estimate of your local computing power,
		-- you should adjust the context window to a larger value.
		context_window = 512,
		provider_options = {
			openai_fim_compatible = {
				-- For Windows users, TERM may not be present in environment variables.
				-- Consider using APPDATA instead.
				api_key = function()
					return "omlx-ryf90d29ztihucmw"
				end,
				name = "oMLX",
				end_point = "http://127.0.0.1:11435/v1/completions",
				model = "Qwen2.5-Coder-14B-Instruct-MLX-4bit",
				optional = {
					max_tokens = 56,
					top_p = 0.9,
				},
			},
		},
	})
end

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
								AI = "[AI]",
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
