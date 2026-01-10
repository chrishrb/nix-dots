local mcpHubCfg = nixCats("mcpHubCfg")

if not mcpHubCfg then
	return
end

require("mcphub").setup({
	config = mcpHubCfg,
	auto_approve = true,
})
