local dap = require("dap")

dap.adapters.php = {
	type = "executable",
	command = "node",
	-- TODO: install php-debug-adapter using nix
	args = { nixCats("phpExtras.php-debug-adapter") .. "/out/phpDebug.js" },
}

dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "Listen for Xdebug",
		port = "9000",
		log = true,
		--  serverSourceRoot = 'localhost:8888',
		--  localSourceRoot = '~/Sites/',
	},
}
