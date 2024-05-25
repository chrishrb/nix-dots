--       __       _     __       __
--  ____/ /  ____(_)__ / /  ____/ /    Christoph Herb
-- / __/ _ \/ __/ (_-</ _ \/ __/ _ \   
-- \__/_//_/_/ /_/___/_//_/_/ /_.__/   http://www.github.com/chrishrb/
--

require('nixCatsUtils').setup {
  non_nix_value = true,
}

require "chrishrb.utils"    -- util functions 
require "chrishrb.plugins"  -- load plugins
require "chrishrb.lsp"      -- lsp configuration

require "chrishrb.config.options"          -- general configuration
require "chrishrb.config.keymaps"          -- keymaps
require "chrishrb.config.commands"         -- user specifi commands
require "chrishrb.config.disable_builtins" -- disable not used builtins
require "chrishrb.autocommands"            -- user specific autocommands
