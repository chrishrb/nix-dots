local dap, dapui, nvim_dap_virtual_text = require("dap"), require("dapui"), require("nvim-dap-virtual-text")

local icons = require("chrishrb.config.icons")

-- dap-ui
dapui.setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	-- Expand lines larger than the window
	-- Requires >= 0.7
	expand_lines = vim.fn.has("nvim-0.7"),
	-- Layouts define sections of the screen to place windows.
	-- The position can be "left", "right", "top" or "bottom".
	-- The size specifies the height/width depending on position. It can be an Int
	-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
	-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
	-- Elements are the elements shown in the layout (in order).
	-- Layouts are opened in order so that earlier layouts take priority in window sizing.
	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				-- "stacks",
				-- "watches",
			},
			size = 40, -- 40 columns
			position = "right",
		},
		{
			elements = {
				"repl",
				--[[ "console", ]]
			},
			size = 0.25, -- 25% of total lines
			position = "bottom",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil, -- Can be integer or nil.
	},
})
vim.fn.sign_define("DapBreakpoint", { text = icons.ui.Bug, texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapStopped",
	{ text = icons.ui.BoldArrowRight, texthl = "DiagnosticSignWarn", linehl = "Visual", numhl = "DiagnosticSignWarn" }
)

-- nvim dap visual line
nvim_dap_virtual_text.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

-- add keybindings
local which_key = require("which-key")
which_key.add({
	{
		{ "<leader>d", group = "Debug", nowait = true, remap = false },
		{ "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Out" },
		{ "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Breakpoint" },
		{ "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
		{ "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Into" },
		{ "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Last" },
		{ "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Over" },
		{ "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Repl" },
		{ "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "UI" },
		{ "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", desc = "Exit" },
	},
})

-- install lang specific configs
if nixCats("go") then
	require("chrishrb.dap.go")
end

if nixCats("python") then
	require("chrishrb.dap.python")
end

if nixCats('php') then
  require("chrishrb.dap.php")
end
