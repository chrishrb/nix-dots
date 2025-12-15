local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = nixCats("typescriptExtras.vue-language-server")
		.. "/lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin",
	languages = { "vue" },
}

return {
	init_options = {
		plugins = {
			vue_plugin,
		},
	},
	filetypes = tsserver_filetypes,
}
