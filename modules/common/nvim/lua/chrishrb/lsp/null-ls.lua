local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion
-- local hover = null_ls.builtins.hover
--[[ local code_actions = null_ls.builtins.code_actions ]]

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
		formatting.stylua,
    diagnostics.pylint,
    diagnostics.mypy,
    formatting.isort,
    formatting.nixfmt
	},
})
