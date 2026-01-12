local tools = {
	read = "read_file",
	write = "neovim__write_file",
	find = "neovim__find_files",
	cmd_runner = "cmd_runner",
}

-- Smart directory discovery function
local function smart_tree()
	-- If tree is available, use it (already smart about structure)
	if vim.fn.executable("tree") == 1 then
		return vim.fn.system(
			"tree -L 2 -a -I '.git|.bzr|node_modules|venv|__pycache__|dist|build|vendor|target' --noreport"
		)
	end

	-- Build smart listing without tree
	local output = {}

	-- 1. Always show directories (structure is important)
	local dirs = vim.fn.systemlist(
		"find . -maxdepth 2 -type d -not -path '*/\\.*' -not -path '*/node_modules/*' -not -path '*/venv/*' -not -path '*/target/*' 2>/dev/null | sort"
	)
	for _, dir in ipairs(dirs) do
		if dir ~= "." then
			table.insert(output, dir .. "/")
		end
	end

	-- 2. Important files (always show these)
	local important_patterns = {
		"README*",
		"LICENSE*",
		"CHANGELOG*",
		"CONTRIBUTING*",
		"Makefile",
		"Dockerfile",
		"docker-compose.yml",
		"package.json",
		"package-lock.json",
		"yarn.lock",
		"pnpm-lock.yaml",
		"pyproject.toml",
		"setup.py",
		"requirements*.txt",
		"Pipfile",
		"Cargo.toml",
		"Cargo.lock",
		"go.mod",
		"go.sum",
		"pom.xml",
		"build.gradle",
		"settings.gradle",
		"composer.json",
		"composer.lock",
		"*.sln",
		"*.csproj",
		"tsconfig.json",
		"webpack.config.*",
		"vite.config.*",
		"rollup.config.*",
		".cursorrules",
		".clinerules",
		"CLAUDE.md",
		"AGENTS.md",
	}

	local important_files = {}
	for _, pattern in ipairs(important_patterns) do
		local files = vim.fn.glob(pattern, false, true)
		for _, file in ipairs(files) do
			important_files[file] = true
			table.insert(output, file)
		end
	end

	-- Helper function to check if file matches swapfile patterns
	local function is_swapfile(filename)
		local basename = vim.fn.fnamemodify(filename, ":t")

		-- Common swapfile/temp patterns
		local patterns = {
			"^~%d+~$", -- ~1~, ~2~, etc.
			"%.swp$", -- vim swap files
			"%.swo$", -- vim swap files
			"%.swx$", -- vim swap files
			"%.tmp$", -- temp files
			"%.temp$", -- temp files
			"^#.*#$", -- emacs auto-save
			"%.bak$", -- backup files
			"%.backup$", -- backup files
			"^%..*%.un~$", -- vim undo files
			"^4913$", -- vim special swap file
			"^%.DS_Store$", -- macOS
			"^Thumbs%.db$", -- Windows
			"^desktop%.ini$", -- Windows
			".*~$", -- general backup pattern
		}

		for _, pattern in ipairs(patterns) do
			if basename:match(pattern) then
				return true
			end
		end

		return false
	end

	-- 3. Sample files by extension (group similar files)
	local all_files = vim.fn.systemlist("find . -maxdepth 1 -type f -not -path '*/\\.*' 2>/dev/null")
	local by_ext = {}

	-- Group remaining files by extension
	for _, file in ipairs(all_files) do
		if not important_files[file] and not is_swapfile(file) then
			local ext = file:match("%.([^%.]+)$") or "no_ext"
			by_ext[ext] = by_ext[ext] or {}
			table.insert(by_ext[ext], file)
		end
	end

	-- Show sample + count for each extension
	for ext, files in pairs(by_ext) do
		table.sort(files) -- Consistent ordering
		if #files <= 3 then
			-- Few files, show all
			for _, file in ipairs(files) do
				table.insert(output, file)
			end
		else
			-- Many files, show sample + count
			table.insert(output, files[1])
			table.insert(output, files[2])
			table.insert(output, string.format("... (%d more .%s files)", #files - 2, ext))
		end
	end

	return table.concat(output, "\n")
end

local system_prompt = {
	name = "System Prompt",
	role = "system",
	content = [[You are a technical documentation expert specializing in creating structured, modular project rules for AI assistants.

Your task is to analyze this codebase and generate focused documentation files that will help AI assistants work effectively on this project. These files will be imported selectively based on the task at hand (e.g., only loading testing.md when writing tests).

### Critical Guidelines for Writing Rules

#### Be Direct and Prescriptive
- Write as a subject matter expert documenting established standards
- State facts definitively: "This project uses pytest" NOT "It looks like this project uses pytest"
- Avoid hedging language: "seems", "appears to be", "looks like", "might be"
- No meta-commentary about the discovery process

#### Focus on Actionable Information
- "Use Black with line length 100" NOT "I noticed the code seems to follow Black formatting"
- "Tests live in tests/ directory" NOT "It appears tests are organized in a tests/ directory"
- Include concrete examples from the actual codebase

#### Keep Rules Concise and Focused
- Each rule file should be under 500 lines
- Favor clarity and brevity over exhaustive detail
- Avoid duplication - reference other files when needed

#### Use Proper Domain Terminology
- Frame guidance in terms appropriate to the domain:
  - Web apps: APIs, routes, component structure, data flow
  - Backend: services, repositories, middleware, error handling
  - Frontend: components, state management, routing, styling
- Use framework-specific terminology accurately

#### Provide Context with Examples
- Document actual conventions used in this codebase, not generic best practices
- Include real code snippets and patterns from the project
- Note project-specific patterns and idioms

#### Examples of Bad vs Good Writing

BAD - Observational and Vague:
"It looks like this is a Python library that appears to use FastAPI for building REST APIs. The code seems to follow PEP 8 conventions and it looks like the developers prefer async/await patterns."

GOOD - Direct and Specific:
"FastAPI 0.104.x web service with async/await throughout. Follows PEP 8 with Black formatting (line length 100)."

BAD - Hedging and Generic:
"I can see that tests are written using pytest and it seems like they follow the arrange-act-assert pattern."

GOOD - Definitive with Examples:
"Tests use pytest with arrange-act-assert pattern. Fixtures defined in conftest.py."

BAD - Patch-Level Thinking:
"Add a try-catch block when calling the API."

GOOD - Design-Level Thinking:
"API calls use centralized error handling via ApiClient class. All errors logged with request context and mapped to user-friendly messages."]],
}

local prompts = {
	analysis = function()
		local tree = smart_tree()

		return string.format(
			[[### Initialize Rules System

**Step 1: Analyze Project**

Directory structure:
```
%s
```

Based on this:
1. What is the primary language/framework?
2. Identify key files:
   - Build config (Makefile, package.json, pyproject.toml, etc.)
   - README or docs
   - Test directory/files
3. List 3-5 essential files to read

Format as:
```
Language/Framework: [your analysis]
Key files:
- [file] - [purpose]
```]],
			tree
		)
	end,
	create_project_md = function()
		return [[**Create project.md**

First, use @{]] .. tools.read .. [[} to read the files you identified.

Then use @{]] .. tools.write .. [[} to create `.rules/project.md` with:

### Language & Framework
- Primary language and version
- Framework(s) used
- Key dependencies

### Project Structure
- How code is organized
- Main directories and their purposes
- Entry points

### Coding Standards
- Naming conventions (functions, classes, variables, files)
- Code style (indentation, line length, etc.)
- Documentation requirements (comments, docstrings)
- Import/dependency organization

### Common Patterns
- Architectural patterns used
- How to structure new modules/features
- Error handling approach

Keep it focused on "what" and "how to write code" - not commands or testing.

Use @{]] .. tools.write .. [[} to create and write the file]]
	end,
	create_testing_md = function()
		-- Find test files
		local test_patterns = {
			"test_*.py",
			"*_test.py", -- Python
			"*.test.js",
			"*.test.ts",
			"*.spec.js",
			"*.spec.ts", -- JS/TS
			"*_test.go", -- Go
			"*_test.rs", -- Rust
			"*Test.java", -- Java
		}

		local test_files = {}
		for _, pattern in ipairs(test_patterns) do
			local found = vim.fn.glob(pattern, false, true)
			for _, file in ipairs(found) do
				table.insert(test_files, file)
				if #test_files >= 3 then
					break
				end
			end
			if #test_files >= 3 then
				break
			end
		end

		-- Also check common test directories
		local test_dirs = { "tests", "test", "__tests__", "spec" }
		for _, dir in ipairs(test_dirs) do
			if vim.fn.isdirectory(dir) == 1 then
				local found = vim.fn.glob(dir .. "/*", false, true)
				for _, file in ipairs(found) do
					if vim.fn.isdirectory(file) == 0 then
						table.insert(test_files, file)
						if #test_files >= 3 then
							break
						end
					end
				end
			end
			if #test_files >= 3 then
				break
			end
		end

		if #test_files > 0 then
			local test_file_list = table.concat(test_files, "\n")

			return string.format([[**Step 3: Create testing.md**

Test files found:
```
%s
```

Use @{]] .. tools.read .. [[} to read 1-2 representative test files to understand patterns.

Then create `.rules/testing.md` with:

### Testing Framework
- Framework/library used (pytest, jest, go test, jasmine, phpunit, etc.)
- Test runner configuration

### Test Organization
- Where tests live
- Naming conventions for test files and functions
- How tests are structured (arrange/act/assert, given/when/then, etc.)

### Writing Tests
- How to write a typical test
- Fixture/mock patterns used
- Test data management
- Common assertions

### Running Tests
- Run all tests
- Run specific test file
- Run specific test function
- Run with coverage
- Watch mode (if applicable)

### Best Practices
- What to test
- What NOT to test
- Coverage expectations
- When to use mocks vs real dependencies

Include concrete examples from the actual test files.

Use @{]] .. tools.write .. [[} to write `.rules/testing.md`]], test_file_list)
		else
			return [[**Step 3: Create testing.md**

Locate the test files in this project.

Use @{]] .. tools.cmd_runner .. [[} and @{]] .. tools.read .. [[} to find and read 1-2 representative test files.

Then create `.rules/testing.md` with:

### Testing Framework
- Framework/library used (pytest, jest, go test, etc.)
- Test runner configuration

### Test Organization
- Where tests live
- Naming conventions for test files and functions
- How tests are structured (arrange/act/assert, given/when/then, etc.)

### Writing Tests
- How to write a typical test
- Fixture/mock patterns used
- Test data management
- Common assertions

### Running Tests
- Run all tests
- Run specific test file
- Run specific test function
- Run with coverage
- Watch mode (if applicable)

### Best Practices
- What to test
- What NOT to test
- Coverage expectations
- When to use mocks vs real dependencies

Include concrete examples from the actual test files.

Use @{]] .. tools.write .. [[} to write `.rules/testing.md`]]
		end
	end,
}

---Creates structured, modular rules in .rules/ directory - single prompt version
---All files created in one response
return {
	["Init Rules (Single Prompt) 2"] = {
		name = "Init Rules (Single Prompt) 2",
		interaction = "chat",
		description = "Initialize project rules in one prompt (.rules/) and follow cursor best practices",
		opts = {
			alias = "init",
			is_slash_cmd = true,
			ignore_system_prompt = true,
		},

		prompts = {
			system_prompt,
			{
				name = "Create All Rules",
				role = "user",
				opts = {
					auto_submit = false,
				},
				content = function()
					local tree = smart_tree()

					return [[### Initialize Rules System

You will create two focused documentation files in `.rules/`:
- `project.md` - Language, frameworks, coding standards
- `testing.md` - Testing patterns and practices

Work through these sequentially, creating each file after gathering the necessary information.

### Project Structure

```
]] .. tree .. [[
```

### Instructions

#### Step 1: Create project.md

1. Identify the primary language and framework from the directory structure
2. Use @{]] .. tools.read .. [[} to read key files:
   - README or similar documentation
   - Build configuration (package.json, pyproject.toml, Cargo.toml, etc.)
   - Main entry point files
3. Create `.rules/project.md` using @{]] .. tools.write .. [[} with:

**Required sections:**
- Language & Framework (language, version, framework, key dependencies)
- Project Structure (directory organization, entry points)
- Coding Standards (naming conventions, code style, documentation requirements)
- Common Patterns (architectural patterns, error handling)

#### Step 2: Create testing.md

1. Locate test files (search for test_*.py, *.test.js, *_test.go, etc.)
2. Use @{]] .. tools.read .. [[} to read 1-2 representative test files
3. Create `.rules/testing.md` using @{]] .. tools.write .. [[} with:

**Required sections:**
- Testing Framework (framework, configuration)
- Test Organization (location, naming, structure)
- Writing Tests (how to write tests, fixtures, mocks, assertions)
- Running Tests (commands for running tests in different ways)
- Best Practices (what to test, coverage expectations)

### Execution

Work through these two steps in order. After creating each file, briefly confirm what you created before moving to the next step. Create all three files in this single response.

Remember: Write definitively. Say "Uses pytest" not "Seems to use pytest". No hedging, no meta-commentary.]]
				end,
			},
		},
	},
	["Init Rules - Analysis (Workflow Step 1)"] = {
		name = "Init Rules - Analysis (Workflow Step 1)",
		interaction = "chat",
		description = "Analyze the current project",
		opts = {
			alias = "init-00_analysis",
			is_slash_cmd = true,
			ignore_system_prompt = true,
		},
		prompts = {
			system_prompt,
			{
				name = "Analyze Structure",
				role = "user",
				opts = { auto_submit = false },
				content = prompts.analysis,
			},
		},
	},
	["Init Rules - project.md (Workflow Step 2)"] = {
		name = "Init Rules - project.md (Workflow Step 2)",
		interaction = "chat",
		description = "Create project.md",
		opts = {
			alias = "init-01_project",
			is_slash_cmd = true,
			ignore_system_prompt = true,
		},
		prompts = {
			system_prompt,
			{
				name = "Create Project",
				role = "user",
				opts = { auto_submit = false },
				content = prompts.create_project_md,
			},
		},
	},
	["Init Rules - testing.md (Workflow Step 3)"] = {
		name = "Init Rules - testing.md (Workflow Step 3)",
		interaction = "chat",
		description = "Create testing.md",
		opts = {
			alias = "init-02_testing",
			is_slash_cmd = true,
			ignore_system_prompt = true,
		},
		prompts = {
			system_prompt,
			{
				name = "Create Testing",
				role = "user",
				opts = { auto_submit = false },
				content = prompts.create_testing_md,
			},
		},
	},
	["Init Rules - Complete Workflow"] = {
		interaction = "workflow",
		description = "Initialize project rules (.rules/)",
		opts = {
			modes = { "n" },
			is_workflow = true,
		},

		prompts = {
			-- ========================================================================
			-- STEP 1: Analyze Project Structure
			-- ========================================================================
			{
				system_prompt,
				{
					name = "Analyze Structure",
					role = "user",
					opts = {
						auto_submit = false,
					},
					content = prompts.analysis,
				},
			},

			-- ========================================================================
			-- STEP 2: Create project.md
			-- ========================================================================
			{
				{
					name = "Create project.md",
					role = "user",
					opts = { auto_submit = false },
					content = prompts.create_project_md,
				},
			},

			-- ========================================================================
			-- STEP 3: Create testing.md
			-- ========================================================================
			{
				{
					name = "Create testing.md",
					role = "user",
					opts = { auto_submit = false },
					content = prompts.create_testing_md,
				},
			},
		},
	},
}
