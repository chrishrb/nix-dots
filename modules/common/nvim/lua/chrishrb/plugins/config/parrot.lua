require("parrot").setup {
  -- Providers must be explicitly added to make them available.
  providers = {
    ollama = {},
  },
  -- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
  -- values: popup / split / vsplit / tabnew
  toggle_target = "vsplit",
  -- use prompt buftype for chats (:h prompt-buffer)
  chat_prompt_buf_type = true,
  -- extra commands
  hooks = {
    Ask = function(prt, params)
      local template = [[
        You are an expert in {{filetype}}.
        In light of your existing knowledge base, please generate a response that
        is succinct and directly addresses the question posed. Prioritize accuracy
        and relevance in your answer, drawing upon the most recent information
        available to you. Aim to deliver your response in a concise manner,
        focusing on the essence of the inquiry.
        Question: {{command}}
      ]]
      local model_obj = prt.get_model("command")
      prt.Prompt(params, prt.ui.Target.vnew, model_obj, "🤖 Ask ~ ", template)
    end,
    AskSelection = function(prt, params)
      local template = [[
        You are an expert in {{filetype}}.

        In light of your existing knowledge base, please generate a response that
        is succinct and directly addresses the question posed. Prioritize accuracy
        and relevance in your answer, drawing upon the most recent information
        available to you. Aim to deliver your response in a concise manner,
        focusing on the essence of the inquiry.

        Use the following context: 
        ```{{filetype}}
        {{selection}}
        ```

        Question: {{command}}
      ]]
      local model_obj = prt.get_model("command")
      prt.Prompt(params, prt.ui.Target.vnew, model_obj, "🤖 Ask ~ ", template)
    end,
    Explain = function(prt, params)
      local template = [[
      Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
      Break down the code's functionality, purpose, and key components.
      The goal is to help the reader understand what the code does and how it works.

      ```{{filetype}}
      {{selection}}
      ```

      Use the markdown format with codeblocks and inline code.
      Explanation of the code above:
      ]]
      local model = prt.get_model "command"
      prt.logger.info("Explaining selection with model: " .. model.name)
      prt.Prompt(params, prt.ui.Target.vnew, model, nil, template)
    end,
    FixBugs = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Fix bugs in the below code from {{filename}} carefully and logically:
      Your task is to analyze the provided {{filetype}} code snippet, identify
      any bugs or errors present, and provide a corrected version of the code
      that resolves these issues. Explain the problems you found in the
      original code and how your fixes address them. The corrected code should
      be functional, efficient, and adhere to best practices in
      {{filetype}} programming.

      ```{{filetype}}
      {{selection}}
      ```

      Fixed code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
    end,
    Optimize = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Your task is to analyze the provided {{filetype}} code snippet and
      suggest improvements to optimize its performance. Identify areas
      where the code can be made more efficient, faster, or less
      resource-intensive. Provide specific suggestions for optimization,
      along with explanations of how these changes can enhance the code's
      performance. The optimized code should maintain the same functionality
      as the original code while demonstrating improved efficiency.

      ```{{filetype}}
      {{selection}}
      ```

      Optimized code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Optimizing selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
    end,
    UnitTests = function(prt, params)
      local template = [[
      I have the following code from {{filename}}:

      ```{{filetype}}
      {{selection}}
      ```

      Please respond by writing table driven unit tests for the code above.
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
    end,
    Debug = function(prt, params)
      local template = [[
      I want you to act as {{filetype}} expert.
      Review the following code, carefully examine it, and report potential
      bugs and edge cases alongside solutions to resolve them.
      Keep your explanation short and to the point:

      ```{{filetype}}
      {{selection}}
      ```
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Debugging selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
    end,
    CommitMsg = function(prt, params)
      local futils = require "parrot.file_utils"
      if futils.find_git_root() == "" then
        prt.logger.warning "Not in a git repository"
        return
      else
        local template = [[
        I want you to act as a commit message generator. I will provide you
        with information about the task and the prefix for the task code, and
        I would like you to generate an appropriate commit message using the
        conventional commit format. Do not write any explanations or other
        words, just reply with the commit message.
        Start with a short headline as summary but then list the individual
        changes in more detail.

        Here are the changes that should be considered by this message:
        ]] .. vim.fn.system "git diff --no-color --no-ext-diff --staged"
        local model_obj = prt.get_model "command"
        prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
      end
    end,
    SpellCheck = function(prt, params)
      local chat_prompt = [[
      Your task is to take the text provided and rewrite it into a clear,
      grammatically correct version while preserving the original meaning
      as closely as possible. Correct any spelling mistakes, punctuation
      errors, verb tense issues, word choice problems, and other
      grammatical mistakes.
      ]]
      prt.ChatNew(params, chat_prompt)
    end,
    CodeConsultant = function(prt, params)
      local chat_prompt = [[
        Your task is to analyze the provided {{filetype}} code and suggest
        improvements to optimize its performance. Identify areas where the
        code can be made more efficient, faster, or less resource-intensive.
        Provide specific suggestions for optimization, along with explanations
        of how these changes can enhance the code's performance. The optimized
        code should maintain the same functionality as the original code while
        demonstrating improved efficiency.

        Here is the code
        ```{{filetype}}
        {{filecontent}}
        ```
      ]]
      prt.ChatNew(params, chat_prompt)
    end,
    ProofReader = function(prt, params)
      local chat_prompt = [[
      I want you to act as a proofreader. I will provide you with texts and
      I would like you to review them for any spelling, grammar, or
      punctuation errors. Once you have finished reviewing the text,
      provide me with any necessary corrections or suggestions to improve the
      text. Highlight the corrected fragments (if any) using markdown backticks.

      When you have done that subsequently provide me with a slightly better
      version of the text, but keep close to the original text.

      Finally provide me with an ideal version of the text.

      Whenever I provide you with text, you reply in this format directly:

      ## Corrected text:

      {corrected text, or say "NO_CORRECTIONS_NEEDED" instead if there are no corrections made}

      ## Slightly better text

      {slightly better text}

      ## Ideal text

      {ideal text}
      ]]
      prt.ChatNew(params, chat_prompt)
    end,
    Docstrings = function(prt, params)
      local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Your task is to write short, concise docstrings.
        Respond just with the snippet of code that should be inserted.
      ]]
      local model_obj = prt.get_model("command")
      prt.Prompt(params, prt.ui.Target.prepend, model_obj, nil, template)
    end,
  }
}

-- setup which-key mappings
local which_key = require("which-key")
which_key.add({
  {
    { "<leader>c", group = "Parrot (AI)", nowait = true, remap = false },
    { "<leader>cc", "<cmd>PrtAsk<CR>", desc = "Quick chat", nowait = true, remap = false },
    { "<leader>ct", "<cmd>PrtChatToggle<CR>", desc = "Toggle chat", nowait = true, remap = false },
    { "<leader>co", "<cmd>PrtCodeConsultant<CR>", desc = "Optimize code", nowait = true, remap = false },
    { "<leader>cm", "<cmd>PrtCommitMsg<CR>", desc = "Generate commmit messages", nowait = true, remap = false },
    {
      mode = { "v" },
      { "<leader>c", group = "Parrot (AI)", nowait = true, remap = false },
      { "<leader>cc", ":PrtAskSelection<CR>", desc = "Quick chat", nowait = true, remap = false },
      { "<leader>ci", ":PrtImplement<CR>", desc = "Generate code from comment", nowait = true, remap = false },
      { "<leader>cr", ":PrtRewrite<CR>", desc = "Rewrite code", nowait = true, remap = false },
      { "<leader>ce", ":PrtExplain<CR>", desc = "Explain code", nowait = true, remap = false },
      { "<leader>cf", ":PrtFixBugs<CR>", desc = "Fix bugs in selected code", nowait = true, remap = false },
      { "<leader>co", ":PrtOptimize<CR>", desc = "Optimize code", nowait = true, remap = false },
      { "<leader>ct", ":PrtUnitTests<CR>", desc = "Generate unittests", nowait = true, remap = false },
      { "<leader>cD", ":PrtDocstrings<CR>", desc = "Generate docstrings", nowait = true, remap = false },
    },
  }
})
