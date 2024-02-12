local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
	return
end

-- ensured installed by mason
local servers = {
  "cssls",
  "html",
  "jdtls",
  "jsonls",
  "lua_ls",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "rust_analyzer",
  "gopls",
  "texlab",
  "volar",
  "terraformls",
  "tailwindcss",
  -- "ltex",
}

mason.setup()
mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("lsp.handlers").on_attach,
    capabilities = require("lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  if server == "jsonls" then
    local jsonls_opts = require "lsp.settings.jsonls"
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server == "lua_ls" then
	 	local lua_ls_opts = require("lsp.settings.lua_ls")
	 	opts = vim.tbl_deep_extend("force", lua_ls_opts, opts)
  end

  if server == "jdtls" then
    goto continue
  end

  if server == "rust_analyzer" then
    local rust_opts = require "lsp.settings.rust"
    local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
    if not rust_tools_status_ok then
      return
    end

    rust_tools.setup(rust_opts)
    goto continue
  end

  if server == "gopls" then
    local go_opts = require "lsp.settings.go"
    local go_tools_status_ok, go_tools = pcall(require, "go")
    if not go_tools_status_ok then
      return
    end

    go_tools.setup(go_opts)
	 	opts = vim.tbl_deep_extend("force", require('go.lsp').config(), opts)
  end

  lspconfig[server].setup(opts)
  ::continue::
end

-- not managed by mason
local dartls_opts = require "lsp.settings.dartls"
local flutter_tools_status_ok, flutter_tools = pcall(require, "flutter-tools")
if flutter_tools_status_ok then
  flutter_tools.setup(dartls_opts)
end

require("lsp.settings.pls")
