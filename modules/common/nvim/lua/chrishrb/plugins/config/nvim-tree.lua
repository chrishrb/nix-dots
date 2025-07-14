-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
local nvim_tree = require("nvim-tree")
local icons = require("chrishrb.config.icons")

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = false,
	update_cwd = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = false,
		icons = {
			hint = icons.diagnostics.BoldHint,
			info = icons.diagnostics.BoldInformation,
			warning = icons.diagnostics.BoldWarning,
			error = icons.diagnostics.BoldError,
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = true,
		custom = {
			"__pycache__",
		},
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
	view = {
		width = 40,
		side = "left",
		number = false,
		relativenumber = false,
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	actions = {
		open_file = {
			resize_window = true,
		},
	},
	renderer = {
		icons = {
			glyphs = {
				default = icons.ui.Text:gsub("%s+", ""), -- remove spaces from Text symbol
				symlink = icons.ui.FileSymlink,
				git = {
					unstaged = icons.git.FileUnstaged,
					staged = icons.git.FileStaged,
					unmerged = icons.git.FileUnmerged,
					renamed = icons.git.FileRenamed,
					deleted = icons.git.FileDeleted,
					untracked = icons.git.FileUntracked,
					ignored = icons.git.FileIgnored,
				},
				folder = {
					default = icons.ui.Folder,
					open = icons.ui.FolderOpen,
					empty = icons.ui.EmptyFolder,
					empty_open = icons.ui.EmptyFolderOpen,
					symlink = icons.ui.FolderSymlink,
				},
			},
		},
	},
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")
		local luv = vim.loop

		local function add_reference(chat, path)
			local filemod = require("codecompanion.strategies.chat.slash_commands.file")
			local slash_command = filemod.new({
				Chat = chat,
				config = {},
				context = {},
				opts = {},
			})
			slash_command:output({
				path = path,
			})
		end

		-- Function to recursively add files in a directory to chat references
		local function traverse_directory(path, chat)
			local handle, err = luv.fs_scandir(path)
			if not handle then
				return print("Error scanning directory: " .. err)
			end

			while true do
				local name, type = luv.fs_scandir_next(handle)
				if not name then
					break
				end

				local item_path = path .. "/" .. name
				if type == "file" then
					-- add the file to references
					add_reference(chat, item_path)
				elseif type == "directory" then
					-- recursive call for a subdirectory
					traverse_directory(item_path, chat)
				end
			end
		end

		-- Attach default mappings
		api.config.mappings.default_on_attach(bufnr)

		-- CodeCompanion integration
		local status_ok_codecompanion, codecompanion = pcall(require, "codecompanion")
		if status_ok_codecompanion then
			vim.keymap.set("n", ".", function()
				local node = api.tree.get_node_under_cursor()
				local path = node.absolute_path
				local chat = codecompanion.last_chat()

				-- create chat if none exists
				if chat == nil then
					chat = codecompanion.chat()
				end

				local attr = luv.fs_stat(path)
				if attr and attr.type == "directory" then
					-- Recursively traverse the directory
					traverse_directory(path, chat)
				else
					-- if already added, ignore
					for _, ref in ipairs(chat.refs) do
						if ref.path == path then
							return print("Already added")
						end
					end
					add_reference(chat, path)
				end
			end, { buffer = bufnr, desc = "Add or Pin file to Chat" })
		end
	end,
})

-- open on startup for directories
local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1
	if not directory then
		return
	end
	-- change to the directory
	vim.cmd.cd(data.file)
	-- open the tree
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
