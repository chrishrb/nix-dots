local adapter = nixCats("aiProvider")

return {
	strategy = "chat",
	description = "Chat with free model (gpt-4.1)",
	opts = {
		alias = "free-chat",
		adapter = {
			name = adapter,
			model = "gpt-4.1",
		},
	},
	prompts = {
		{
			role = "system",
			content = require("chrishrb.plugins.config.codecompanion.system_prompt"),
			opts = {
				auto_submit = true,
			},
		},
		{
			role = "user",
			content = "",
			opts = {
				auto_submit = false,
			},
		},
	},
}
