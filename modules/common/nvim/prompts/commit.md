---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  adapter:
    name: copilot
    model: gpt-4.1
  alias: commit
  auto_submit: false
  is_slash_cmd: true
  modes:
    - n
---

## user

You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

`````diff
${commit.diff}
`````
