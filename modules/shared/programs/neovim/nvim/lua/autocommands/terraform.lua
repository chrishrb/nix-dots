vim.api.nvim_create_augroup("_terraform", { clear = true })

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = "_terraform",
  pattern = "*hcl",
  callback = function() vim.cmd("set filetype=hcl") end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = "_terraform",
  pattern = ".terraformrc,terraform.rc",
  callback = function() vim.cmd("set filetype=hcl") end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = "_terraform",
  pattern = "*.tf,*.tfvars",
  callback = function() vim.cmd("set filetype=terraform") end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = "_terraform",
  pattern = "*.tfstate,*.tfstate.backup",
  callback = function() vim.cmd("set filetype=json") end,
})
