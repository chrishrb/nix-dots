local adapter = nixCats("aiAdapter")
if not adapter then
  return
end

require("dressing").setup({
  input = {
    enabled = false
  },
  select = {
    enabled = true
  }
})

require("codecompanion").setup({
  display = {
    action_palette = {
      prompt = "🤖 ~ "
    }
  },
  strategies = {
    chat = {
      adapter = adapter,
    },
    inline = {
      adapter = adapter,
    },
    agent = {
      adapter = adapter,
    },
  },
})

-- setup which-key mappings
local which_key = require("which-key")
which_key.add({
  {
    { "<leader>c", group = "CodeCompanion (" .. adapter .. ")", nowait = true, remap = false },
    { "<leader>cc", "<cmd>CodeCompanion<CR>", desc = "Quick chat", nowait = true, remap = false },
    { "<leader>ca", "<cmd>CodeCompanionActions<CR>", desc = "Actions", nowait = true, remap = false },
    { "<leader>co", "<cmd>CodeCompanionChat<CR>", desc = "New Chat", nowait = true, remap = false },
    { "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat", nowait = true, remap = false },
    {
      mode = { "v" },
      { "<leader>c", group = "CodeCompanion (" .. adapter .. ")", nowait = true, remap = false },
      { "<leader>cc", ":CodeCompanion<CR>", desc = "Quick chat", nowait = true, remap = false },
      { "<leader>ca", ":CodeCompanionActions<CR>", desc = "Actions", nowait = true, remap = false },
    },
  }
})

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
