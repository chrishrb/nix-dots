-- setup copilot
local copilot = require("copilot")

copilot.setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

-- setup copilot chat
local chat = require("CopilotChat")
local select = require("CopilotChat.select")

local prompts = {
	-- code related prompts
	Explain = "/COPILOT_EXPLAIN Write an explanation for the code above as paragraphs of text.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "/COPILOT_TESTS Write a set of detailed unit test functions for the code above.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
	Fix = "/COPILOT_FIX There is a problem in this code. Rewrite the code to show it with the bug fixed.",
	Optimize = "/COPILOT_REFACTOR Optimize the selected code to improve performance and readablilty.",
	Docs = "/COPILOT_REFACTOR Write documentation for the selected code. The reply should be a codeblock containing the original code with the documentation added as comments. Use the most appropriate documentation style for the programming language used (e.g. JSDoc for JavaScript, docstrings for Python etc.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	FixDiagnostic = {
		prompt = "Please assist with the following diagnostic issue in file:",
		selection = select.diagnostics,
	},
	Commit = {
		prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
		selection = select.gitdiff,
	},
	CommitStaged = {
		prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
		selection = function(source)
			return select.gitdiff(source, true)
		end,
	},

	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

chat.setup({
	prompts = prompts,
})

-- setup autocommand (custom buffer for chat)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = true
    vim.opt_local.number = true

    -- Get current filetype and set it to markdown if the current filetype is copilot-chat
    local ft = vim.bo.filetype
    if ft == "copilot-chat" then
      vim.bo.filetype = "markdown"
    end
  end,
})

-- setup which-key mappings
local which_key = require("which-key")
local which_key_config = require("chrishrb.plugins.config.whichkey")

local mappings = {
	c = {
		name = "Copilot",
		c = {
			function()
				local input = vim.fn.input("Copilot: ")
				if input ~= "" then
          chat.ask(input, { selection = select.buffer })
				end
			end,
			"Quick chat",
		},
		f = { "<cmd>CopilotChatFix<CR>", "Fix diagnostics" },
		m = { "<cmd>CopilotChatCommit<CR>", "Generate commit message for all changes" },
		t = { "<cmd>CopilotChatToggle<CR>", "Toggle chat" },
	},
}

local vmappings = {
	c = {
		name = "Copilot",
		c = {
			function()
				local input = vim.fn.input("Copilot: ")
				if input ~= "" then
          chat.ask(input, { selection = select.visual })
				end
			end,
			"Quick chat",
		},
		e = { "<cmd>CopilotChatExplain<CR>", "Explain code" },
		t = { "<cmd>CopilotChatTests<CR>", "Generate tests" },
		f = { "<cmd>CopilotChatFix<CR>", "Fix bug in selected code" },
		o = { "<cmd>CopilotChatOptimize<CR>", "Optimize code" },
		r = { "<cmd>CopilotChatRefactor<CR>", "Refactor code" },
		n = { "<cmd>CopilotChatBetterNamings<CR>", "Better naming" },
		R = { "<cmd>CopilotChatReview<CR>", "Review code" },
	},
}

which_key.register(mappings, which_key_config.opts)
which_key.register(vmappings, which_key_config.vopts)
