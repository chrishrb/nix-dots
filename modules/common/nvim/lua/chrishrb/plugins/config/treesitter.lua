local indent_disabled = { "yaml", "python", "java", "terraform" }

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ok = pcall(vim.treesitter.start, args.buf)
		if ok then
			local ft = vim.bo[args.buf].filetype
			if not vim.tbl_contains(indent_disabled, ft) then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})
