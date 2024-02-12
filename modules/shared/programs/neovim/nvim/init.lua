
--       __       _     __       __
--  ____/ /  ____(_)__ / /  ____/ /    Christoph Herb
-- / __/ _ \/ __/ (_-</ _ \/ __/ _ \   @jambit
-- \__/_//_/_/ /_/___/_//_/_/ /_.__/   http://www.github.com/chrishrb/
--

require "utils"     -- util functions 
require "plugins"   -- all plugins with lazy.nvim
require "lsp"       -- lsp configuration

safe_load "config.options"          -- general configuration
safe_load "config.keymaps"          -- keymaps
safe_load "config.commands"         -- user specifi commands
safe_load "config.disable_builtins" -- disable not used builtins
safe_load "autocommands"            -- user specific autocommands
