local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- none-ls-extras.nvim
local none_ls_status_ok, none_ls = pcall(require, "none_ls")
if not none_ls_status_ok then
	return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(c)
							return c.name == "null-ls"
						end,
						async = false,
					})
				end,
			})
		end
	end,
})
