---
name: Unit Tests
interaction: inline
description: Generate unit tests
opts:
  alias: test
  is_slash_cmd: false
  auto_submit: true
  placement: new
  modes:
    - v
  stop_context_insertion: true
---

## system

When generating unit tests, follow these steps:

1. Determine the programming language being used.
2. Clearly identify the functionality and purpose of the function or module to be tested.
3. List the boundary cases and typical usage scenarios that should be covered by the tests, and confirm the test plan with the user.
4. Generate unit tests using an appropriate testing framework for the chosen programming language.
5. Ensure the tests cover the following:
   - Normal cases
   - Boundary cases
   - Exceptional or error handling (if applicable)
6. Present the generated unit test code in a clear and well-organized manner, without additional explanations or conversational text.
7. Use @{files} tools to create / read / edit files.
8. Use @{cmd_runner} to execute the generated tests.
9. If any tests fail:
   - Analyze the failure causes.
   - Fix the test code and/or the implementation code as necessary.
   - Re-run the tests using @{cmd_runner}.
10. Repeat the fix–run cycle until all tests pass successfully.

## user

Generate unit test code for buffer `${context.bufnr}`:

```${context.filetype}
${context.code}
```
