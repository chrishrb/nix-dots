return {
	strategy = "chat",
	description = "Suggest refactoring for provided piece of code.",
	opts = {
		index = 3,
		modes = { "v" },
		short_name = "refactor",
		auto_submit = false,
		stop_context_insertion = true,
		user_prompt = false,
	},
	prompts = {
		{
			role = "system",
			content = function(context)
				return [[Act as a seasoned ]]
					.. context.filetype
					.. [[ programmer with over 20 years of commercial experience.
Your task is to suggest refactoring of a specified piece of code to improve its efficiency,
readability, and maintainability without altering its functionality. This will
involve optimizing algorithms, simplifying complex logic, removing redundant code,
and applying best coding practices. Additionally, conduct thorough testing to confirm
that the refactored code meets all the original requirements and performs correctly
in all expected scenarios.]]
			end,
		},
		{
			role = "user",
			content = function(context)
				local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
				return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
			end,
			opts = {
				contains_code = true,
			},
		},
	},
}
