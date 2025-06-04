local constants = require("codecompanion.config").constants

local base_prompt = [[
You are an expert in crafting high-quality commit messages following the Conventional Commit specification. Given a git diff, create a series of commits that adhere to the guidelines provided.

## Task
- Analyze the provided Git diff and break the changes into meaningful, separate commits.
- Ensure **each commit represents a single, logical change**. Group related modifications together.
- Use appropriate commit types (`feat`, `fix`, `refactor`, `chore`, `docs`, `fmt`, etc.).
- If multiple concerns are mixed in a single diff, **split them into separate commits**.
- If there are formatting or style changes, ensure they are committed separately.
- Execute `git commit` for each commit.

## Formatting Guidelines

- Write commit messages in the following format:
type(scope): short description (≤50 characters)

Detailed explanation (wrap at 72 characters)
- List significant changes, if necessary
- Use imperative voice (e.g., "Add feature X", not "Added feature X").
- If necessary, include `BREAKING CHANGE:` for backward-incompatible changes.

## Constraints
- Do **not** verify changes when committing (`--no-verify`).
- Do **not** include unrelated changes in commits.

You may use @cmd_runner to execute necessary Git commands.
]]

return {
  strategy = "workflow",
  description = "Generate conventional commits from staged changes",
  opts = {
    index = 4,
    modes = { "n" },
    short_name = "git_commit",
    auto_submit = true,
  },
  prompts = {
    {
      {
        role = constants.USER_ROLE,
        content = base_prompt,
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = constants.USER_ROLE,
        content = function()
          vim.g.codecompanion_auto_tool_mode = true
          return "@cmd_runner Stash git changes (including untracked and keep index). Run `git reset -N` to unstage changes."
        end,
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = constants.USER_ROLE,
        content = function()
          vim.g.codecompanion_auto_tool_mode = true
          return "@cmd_runner Stash git changes (including untracked and keep index). Run `git reset -N` to unstage changes."
        end,
        opts = {
          auto_submit = true,
        },
      },
    },
    {
      {
        role = constants.USER_ROLE,
        content = function()
          vim.g.codecompanion_auto_tool_mode = true
          return string.format(
            "Generate and execute git commit for conventional commits from diff - execute git commit with --no-verify\ndiff:\n```diff\n%s\n```",
            vim.fn.system("git diff --no-ext-diff")
          )
        end,
        opts = {
          contains_code = true,
          auto_submit = false,
        },
      },
    },
  },
}
