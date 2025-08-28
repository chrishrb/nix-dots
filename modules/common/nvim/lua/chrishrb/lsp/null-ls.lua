local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- none-ls-extras.nvim
local none_ls_status_ok, none_ls = pcall(require, "none_ls")
if not none_ls_status_ok then
	return
end

null_ls.setup({
	debug = false,
	sources = {
		null_ls.builtins.formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.diagnostics.mypy,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.nixfmt,

		none_ls.diagnostics.eslint,
		none_ls.codeactions.eslint,
	},
})
