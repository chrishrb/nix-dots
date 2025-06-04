if not nixCats("go") then
	return
end

local which_key = require("which-key")
which_key.add({
	{
		{ "<leader>dt", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "Run test" },
		{ "<leader>dT", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "Last test" },
	},
})
