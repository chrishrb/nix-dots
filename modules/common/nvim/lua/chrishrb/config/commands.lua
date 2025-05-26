-- autoformat range or file with lsp
vim.api.nvim_create_user_command("LspFormat", "lua vim.lsp.buf.format()", {})

-- open telescope buffer-selection
vim.api.nvim_create_user_command("Buffers", "Telescope buffers", { nargs = 0 })

-- use fixed bdelete instead of bd
vim.cmd([[
  cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Bdelete' : 'bd')<CR>
]])
