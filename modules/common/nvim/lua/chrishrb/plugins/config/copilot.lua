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
which_key.add({
  {
    { "<leader>c", group = "Copilot", nowait = true, remap = false },
    { "<leader>cc", function()
				local input = vim.fn.input("Copilot: ")
				if input ~= "" then
          chat.ask(input, { selection = select.visual })
				end
			end, desc = "Quick chat", nowait = true, remap = false },
    { "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix diagnostics", nowait = true, remap = false },
    { "<leader>cm", "<cmd>CopilotChatCommit<CR>", desc = "Generate commit message for all changes", nowait = true, remap = false },
    { "<leader>ct", "<cmd>CopilotChatToggle<CR>", desc = "Toggle chat", nowait = true, remap = false },
    {
      mode = { "v" },
      { "<leader>c", group = "Copilot", nowait = true, remap = false },
      { "<leader>cR", "<cmd>CopilotChatReview<CR>", desc = "Review code", nowait = true, remap = false },
      { "<leader>cc", function()
				local input = vim.fn.input("Copilot: ")
				if input ~= "" then
          chat.ask(input, { selection = select.visual })
				end
			end, desc = "Quick chat", nowait = true, remap = false },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain code", nowait = true, remap = false },
      { "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix bug in selected code", nowait = true, remap = false },
      { "<leader>cn", "<cmd>CopilotChatBetterNamings<CR>", desc = "Better naming", nowait = true, remap = false },
      { "<leader>co", "<cmd>CopilotChatOptimize<CR>", desc = "Optimize code", nowait = true, remap = false },
      { "<leader>cr", "<cmd>CopilotChatRefactor<CR>", desc = "Refactor code", nowait = true, remap = false },
      { "<leader>ct", "<cmd>CopilotChatTests<CR>", desc = "Generate tests", nowait = true, remap = false },
    },
  }
})
