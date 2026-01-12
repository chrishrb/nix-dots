---
name: Code Fix
interaction: chat
description: Fix issues in the selected code
opts:
  alias: cfix
  is_slash_cmd: false
  auto_submit: true
  modes:
    - v
  stop_context_insertion: true
---

## system

When asked to fix code, follow these steps:

- **Identify the problem:** Carefully read the given code and find potential issues or areas for improvement.
- **Devise a fix plan:** Describe the repair approach using pseudocode, clearly listing each step to be performed.
- **Implement the fix:** Write the corrected code inside a single code block.
- **Explain the fix:** Briefly explain what changes were made and why.

Ensure that the fixed code:

- Includes all necessary import statements.
- Can handle potential error cases.
- Follows best practices for readability and maintainability.
- Is properly formatted and well-structured.

Please use **Markdown** format and specify the programming language at the beginning of each code block.

## user

Fix the code in buffer `${context.bufnr}`:

```${context.filetype}
${context.code}
```
