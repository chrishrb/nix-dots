if not require("nixCatsUtils").isNixCats then
	return
end

vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)")
vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
-- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

local which_key = require("which-key")
which_key.add({
  {
    { "<leader>L", group = "Java", nowait = true, remap = false },
    { "<leader>Lo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", desc = "Organize Imports" },
    { "<leader>Lv", "<Cmd>lua require('jdtls').extract_variable()<CR>", desc = "Extract Variable" },
    { "<leader>Lc", "<Cmd>lua require('jdtls').extract_constant()<CR>", desc = "Extract Constant" },
    { "<leader>Lu", "<Cmd>lua require('jdtls').update_project_config()<CR>", desc = "Update Config" },
    {
      mode = { "v" },
      { "<leader>Lv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", desc = "Extract Variable" },
      { "<leader>Lc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", desc = "Extract Constant" },
      { "<leader>Lm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", desc = "Extract Method" },
    }
  }
})

-- setup java dap settings
local bundles = {}
if nixCats("debug") then
	-- debugger config
	local jda_server_jar = vim.fn.glob(
		nixCats("javaExtras.java-debug-adapter")
			.. "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar"
	)
	local jt_server_jars =
		vim.fn.glob(nixCats("javaExtras.java-test") .. "/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar")

	vim.list_extend(bundles, vim.split(jt_server_jars, "\n"))
	vim.list_extend(bundles, vim.split(jda_server_jar, "\n"))

  which_key.add({
    {
      { "<leader>L", group = "Java", nowait = true, remap = false },
      { "<leader>Lt", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", desc = "Test Method" },
      { "<leader>LT", "<Cmd>lua require'jdtls'.test_class()<CR>", desc = "Test Class" },
    }
  })
end

local config_dir = vim.loop.os_homedir() .. "/.cache/jdtls/config"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.loop.os_homedir() .. "/.cache/jdtls/workspace/" .. project_name

-- return config for java
return {
	on_attach = function(client, buffer)
		require("chrishrb.lsp.handlers").on_attach(client, buffer)

		if nixCats("debug") then
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs() -- discover main class
		end
	end,
  cmd = {
    vim.fn.exepath('jdtls'),

    "--jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "--jvm-arg=-Dosgi.bundles.defaultStartLevel=4",
    "--jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product",
    "--jvm-arg=-Dlog.protocol=true",
    "--jvm-arg=-Dlog.level=ALL",
    "--jvm-arg=-Xmx1g",
    "--jvm-arg=--add-modules=ALL-SYSTEM",
    "--jvm-arg=--add-opens",
    "--jvm-arg=java.base/java.util=ALL-UNNAMED",
    "--jvm-arg=--add-opens",
    "--jvm-arg=java.base/java.lang=ALL-UNNAMED",
    "--jvm-arg=-javaagent:" .. nixCats("javaExtras.lombok") .. "/share/java/lombok.jar",

    '-configuration', config_dir,
    '-data', workspace_dir,
  },
	capabilities = require("chrishrb.lsp.handlers").capabilities,
	settings = {
		java = {
			-- jdt = {
			--   ls = {
			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
			--   }
			-- },
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = true,
				-- settings = {
				--   profile = "asdf"
				-- }
			},
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		contentProvider = { preferred = "fernflower" },
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
		-- debugger
		init_options = {
			-- workspace = workspace_dir,
			bundles = bundles,
		},
	},
}
