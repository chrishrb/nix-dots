local codecompanion = require("codecompanion")
local context_utils = require("codecompanion.utils.context")
local api = vim.api

local adapter = "copilot"
local prefix = "🤖 ~ "

require("dressing").setup({
  input = {
    enabled = false,
  },
  select = {
    enabled = true,
  },
})

codecompanion.setup({
  extensions = {
    vectorcode = {
      opts = {
        add_tool = true,
        tool_opts = {
          ls_on_start = true,
          auto_submit = { query = true }
        }
      }
    },
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
        make_vars = true,           -- make chat #variables from MCP server resources
        make_slash_commands = true, -- make /slash_commands from MCP server prompts
      },
    }
  },
  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.7-sonnet",
          },
        },
      })
    end,
  },
  display = {
    action_palette = {
      prompt = prefix,
    },
    chat = {
      intro_message = "",
      start_in_insert_mode = false,
    },
  },
  strategies = {
    chat = {
      adapter = adapter,
    },
    inline = {
      adapter = adapter,
    },
    cmd = {
      adapter = adapter,
    },
  },
})

-- setup which-key mappings
local which_key = require("which-key")
which_key.add({
  {
    { "<leader>c",  group = "CodeCompanion (" .. adapter .. ")", nowait = true,        remap = false },
    {
      "<leader>cc",
      function()
        local input = vim.fn.input(prefix)
        if input ~= "" then
          codecompanion.chat({ fargs = { "chat" }, args = input, range = 0 })
        end
      end,
      desc = "Quick chat",
      nowait = true,
      remap = false,
    },
    { "<leader>ci", "<cmd>CodeCompanion<CR>",                    desc = "Inline chat", nowait = true, remap = false },
    { "<leader>ca", "<cmd>CodeCompanionActions<CR>",             desc = "Actions",     nowait = true, remap = false },
    { "<leader>co", "<cmd>CodeCompanionChat<CR>",                desc = "New Chat",    nowait = true, remap = false },
    { "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>",         desc = "Toggle chat", nowait = true, remap = false },
    {
      mode = { "v" },
      { "<leader>c",  group = "CodeCompanion (" .. adapter .. ")", nowait = true,       remap = false },
      { "<leader>cc", ":CodeCompanion<CR>",                        desc = "Quick chat", nowait = true, remap = false },
      { "<leader>ca", ":CodeCompanionActions<CR>",                 desc = "Actions",    nowait = true, remap = false },
      {
        "<leader>co",
        function()
          local input = vim.fn.input(prefix)
          if input ~= "" then
            local context = context_utils.get(api.nvim_get_current_buf(), {})
            local content = input .. "\n\nHere is the code from " .. context.filename .. ":\n\n"
            codecompanion.chat({ fargs = { "chat" }, args = content, range = 1 })
          end
        end,
        desc = "Chat with selection",
        nowait = true,
        remap = false,
      },
    },
  },
})

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
