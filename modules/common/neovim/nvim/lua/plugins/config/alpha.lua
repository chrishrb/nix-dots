local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local icons = require "config.icons"

local function footer()
  local status_ok_lazy, lazy = pcall(require, "lazy")
  if not status_ok_lazy then
    return " ?"
  end
  local plugins = lazy.stats()
  local v = vim.version()
  local datetime = os.date " %d-%m-%Y"
  return string.format("%s %s  v%s.%s.%s  %s", icons.ui.Tree, plugins.count, v.major, v.minor, v.patch, datetime)
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
[[                                                                              ]],
[[                                    ██████                                    ]],
[[                                ████▒▒▒▒▒▒████                                ]],
[[                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                              ]],
[[                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ]],
[[                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                              ]],
[[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                          ]],
[[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                          ]],
[[                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        ]],
[[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
[[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
[[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
[[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
[[                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        ]],
[[                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        ]],
[[                        ██      ██      ████      ████                        ]],
[[                                                                              ]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", icons.ui.Files .. " Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", icons.git.Repo .. " Find project", ":Telescope projects <CR>"),
	dashboard.button("r", icons.ui.History .. " Recently used files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", icons.ui.Text .. " Find text", ":Telescope live_grep <CR>"),
	dashboard.button("c", icons.ui.Gear .. " Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("P", icons.ui.Tree .. " Plugins", ":e ~/.config/nvim/lua/user/plugins.lua <CR>"),
	dashboard.button("q", icons.ui.SignOut .. " Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.val = " \n" .. footer()
dashboard.section.footer.opts.hl = "Keyword"
dashboard.section.header.opts.hl = "Keyword"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
