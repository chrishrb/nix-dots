local fmt = string.format

-- TODO: improve this prompt
return {
  strategy = "workflow",
  description = "Generate unit tests for the selected code",
  opts = {
    index = 2,
    modes = { "v" },
    short_name = "tests",
    auto_submit = true,
  },
  prompts = {
    {
      role = "system",
      content = [[When generating unit tests, follow these steps:

1. Identify the programming language.
2. Identify the purpose of the function or module to be tested.
3. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
4. Generate unit tests using an appropriate testing framework for the identified programming language.
5. Ensure the tests cover:
      - Normal cases
      - Edge cases
      - Error handling (if applicable)
6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.
7. Also ensure that the generated tests are compatible with the existing codebase and follow best practices for unit testing in the specified programming language. If the code is not testable, inform the user about it.]],
      opts = {
        visible = false,
      },
    },
    {
      role = "user",
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return fmt([[
Please generate unit tests for this code from buffer %d with the filename `%s`:

```%s
%s
```

You may use the @vectorcode tool to retrieve the style of the existing tests in the codebase, if available. If not, generate tests using the best practices of the programming language %s.
Also retrieve the placement of the existing tests from the current file in the codebase, if available. If not available, generate the tests in a new file with a name that follows the conventions of the programming language %s.]],
          context.bufnr,
          context.filename,
          context.filetype,
          code,
          context.filetype,
          context.filetype
        )
      end,
      opts = {
        contains_code = true,
        auto_submit = true,
      },
    },
    {
      role = "user",
      content = "You may use the @files tool to write the generated tests to the correct file.",
      opts = {
        contains_code = true,
        auto_submit = false,
      },
    },
  },
}
