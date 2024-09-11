-- disable ui input
local dressing = require("dressing")
dressing.setup({
  input = { enabled = false },
  select = { enabled = false }
})

local avante = require("avante.api")

-- setup which-key mappings
local which_key = require("which-key")
which_key.add({
  {
    { "<leader>c", group = "Avante", nowait = true, remap = false },
    { "<leader>cc", function()
				local input = vim.fn.input("Avante: ")
				if input ~= "" then
          avante.ask({ question = input, ask = false })
				end
			end, desc = "Quick chat", nowait = true, remap = false, mode = { "n", "v" } },
    { "<leader>ct", "<cmd>AvanteToggle<CR>", desc = "Toggle", nowait = true, remap = false },
    { "<leader>ca", function() avante.ask() end, desc = "Ask", nowait = true, remap = false, mode = { "n", "v" } },
    { "<leader>cr", function() avante.refresh() end, desc = "Refresh", nowait = true, remap = false, mode = { "v" } },
    { "<leader>ce", function()
				local input = vim.fn.input("Avante: ")
				if input ~= "" then
          avante.edit(input)
				end
			end, desc = "Edit", nowait = true, remap = false, mode = { "v" } },
  }
})

return {
  provider = "ollama",
  vendors = {
     ollama = {
       ["local"] = true,
       endpoint = "127.0.0.1:11434/v1",
       model = "codegemma",
       parse_curl_args = function(opts, code_opts)
         return {
           url = opts.endpoint .. "/chat/completions",
           headers = {
             ["Accept"] = "application/json",
             ["Content-Type"] = "application/json",
           },
           body = {
             model = opts.model,
             messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
             max_tokens = 2048,
             stream = true,
           },
         }
       end,
       parse_response_data = function(data_stream, event_state, opts)
         require("avante.providers").openai.parse_response(data_stream, event_state, opts)
       end,
     },
   },
  mappings = {
    ask = "<leader>ca", -- ask
    edit = "<leader>ce", -- edit
    refresh = "<leader>cr", -- refresh
  },
}
