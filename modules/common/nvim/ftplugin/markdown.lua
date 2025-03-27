local cmp = require("cmp")
local sources = cmp.get_config().sources
table.insert(sources, { name = "emoji" })
cmp.setup.buffer({ sources = sources })
