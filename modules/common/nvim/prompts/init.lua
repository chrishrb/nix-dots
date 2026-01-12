return {
	tree = function()
		if vim.fn.executable("tree") == 1 then
			return vim.fn.system(
				"tree -L 2 -a -I '.git|.bzr|node_modules|venv|__pycache__|dist|build|vendor|target' --noreport"
			)
		end

		local output = {}

		local dirs = vim.fn.systemlist(
			"find . -maxdepth 2 -type d -not -path '*/\\.*' -not -path '*/node_modules/*' -not -path '*/venv/*' -not -path '*/target/*' 2>/dev/null | sort"
		)

		for _, dir in ipairs(dirs) do
			if dir ~= "." then
				table.insert(output, dir .. "/")
			end
		end

		local important_patterns = {
			"README*",
			"LICENSE*",
			"CHANGELOG*",
			"Makefile",
			"Dockerfile",
			"package.json",
			"pyproject.toml",
			"go.mod",
			"Cargo.toml",
			".cursorrules",
			".clinerules",
			"CLAUDE.md",
			"AGENTS.md",
		}

		for _, pattern in ipairs(important_patterns) do
			local files = vim.fn.glob(pattern, false, true)
			for _, file in ipairs(files) do
				table.insert(output, file)
			end
		end

		return table.concat(output, "\n")
	end,
}
