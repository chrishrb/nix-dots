-- category: general
local servers = {
	-- vscode-langservers-extracted
	"cssls",
	"html",
	"jsonls",

	"yamlls",
	"bashls",
	"lua_ls",

	"nil_ls",
	"nixd",
}

-- disable mason for nixCats
if not require("nixCatsUtils").isNixCats then
	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = servers,
		automatic_installation = true,
	})
end

-- debug mode
if require("nixCatsUtils").isNixCats and nixCats("lspDebugMode") then
	vim.lsp.set_log_level("debug")
end

-- add language servers if category is enabled
if nixCats("go") then
	servers[#servers + 1] = "gopls"
end

if nixCats("python") then
	servers[#servers + 1] = "pylsp"
end

if nixCats("java") then
	servers[#servers + 1] = "jdtls"
end

if nixCats("devops") then
	servers[#servers + 1] = "terraformls"
end

if nixCats("latex") then
	servers[#servers + 1] = "texlab"
end

if nixCats("php") then
	servers[#servers + 1] = "phpactor"
end

if nixCats("web") then
	servers[#servers + 1] = "ts_ls"
	servers[#servers + 1] = "tailwindcss"
	servers[#servers + 1] = "volar"
end

-- setup handlers
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("chrishrb.lsp.handlers").on_attach,
		capabilities = require("chrishrb.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	if server == "jsonls" then
		local jsonls_opts = require("chrishrb.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server == "lua_ls" then
		local lua_ls_opts = require("chrishrb.lsp.settings.lua_ls")
		opts = vim.tbl_deep_extend("force", lua_ls_opts, opts)
	end

	if server == "jdtls" then
		local jdtls_ls_opts = require("chrishrb.lsp.settings.jdtls")
		opts = jdtls_ls_opts
	end

	if server == "yamlls" then
		local yamlls_opts = require("chrishrb.lsp.settings.yamlls")
		opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
	end

	if server == "gopls" then
		local gopls_opts = require("chrishrb.lsp.settings.gopls")
		opts = vim.tbl_deep_extend("force", gopls_opts, opts)
	end

	lspconfig[server].setup(opts)
end
