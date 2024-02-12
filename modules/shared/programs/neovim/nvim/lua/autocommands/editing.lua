vim.api.nvim_create_augroup("_editing", { clear = true })

-- Enable spell check and word wrap for certain file types
vim.api.nvim_create_autocmd("FileType", {
  group = "_editing",
  pattern = { "text", "*.md", "*.tex", "markdown" },
  callback = function()
    vim.cmd("setlocal spell")
    vim.cmd("setlocal wrap")
  end,
})
