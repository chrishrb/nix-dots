local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local config = {
  default_config = {
    cmd = { "pls" },
    filetypes = { "proto" },
    root_dir = lspconfig.util.root_pattern('Makefile', '.git'),
  },
  docs = {
    description = [[
https://github.com/lasorda/protobuf-language-server

pls is a protobuf language server
    ]]
  }
}

require("lspconfig.configs").pls = config
lspconfig.pls.setup{}
