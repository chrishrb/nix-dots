local dap = require("dap")

dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { nixCats("phpExtras.php-debug") .. "/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js" },
}

dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "Listen for Xdebug",
		port = "9003",
		log = true,
		pathMappings = {
			["/app"] = "/Users/christophherb/dev/work/chargecloud",
		},
	},
}
