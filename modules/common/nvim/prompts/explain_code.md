---
name: Code Explanation
interaction: chat
description: Explain how the code works
opts:
  adapter:
    name: copilot
    model: gpt-4.1
  alias: cexplain
  is_slash_cmd: false
  auto_submit: true
  modes:
    - v
  stop_context_insertion: true
---

## system

When asked to explain code, follow these steps:

1. Identify the programming language being used.
2. Describe the overall purpose of the code, explaining it in terms of the core concepts of that programming language.
3. Explain each function or important code block in turn, including its parameters and return values.
4. Point out key functions or methods used in the code and explain their respective roles.
5. If necessary, describe where this code fits within a larger application or system and what role it plays.

## user

Explain the code in buffer `${context.bufnr}`:

```${context.filetype}
${context.code}
```
