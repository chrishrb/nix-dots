local minuet = require('minuet')

minuet.setup {
  provider = nixCats("aiProvider"),
  add_single_line_entry = false,
  provider_options = {
    gemini = {
      optional = {
        generationConfig = {
          maxOutputTokens = 256,
          -- When using `gemini-2.5-flash`, it is recommended to entirely
          -- disable thinking for faster completion retrieval.
          thinkingConfig = {
            thinkingBudget = 0,
          },
        },
        safetySettings = {
          {
            -- HARM_CATEGORY_HATE_SPEECH,
            -- HARM_CATEGORY_HARASSMENT
            -- HARM_CATEGORY_SEXUALLY_EXPLICIT
            category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
            -- BLOCK_NONE
            threshold = 'BLOCK_ONLY_HIGH',
          },
        },
      }
    }
  }
}
