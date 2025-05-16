local mcpHubConfigFile = nixCats("mcpHubConfigFile")

require("mcphub").setup({
	config = mcpHubConfigFile,
	auto_approve = true,
})
