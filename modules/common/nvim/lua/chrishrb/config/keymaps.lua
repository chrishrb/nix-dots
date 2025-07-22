local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- enable horizontal resize only when there are windows to resize otherwise
-- the the command line will be resized
local function has_horizontal_split()
	local cur_win = vim.api.nvim_get_current_win()
	local cur_info = vim.fn.getwininfo(cur_win)[1]

	for _, win in ipairs(vim.fn.getwininfo()) do
		if win.winid ~= cur_win then
			if win.wincol == cur_info.wincol and win.winrow ~= cur_info.winrow then
				return true
			end
		end
	end

	return false
end

-- Normal --
-- Resize with arrows
vim.keymap.set("n", "<C-Up>", function()
	if has_horizontal_split() then
		vim.cmd("resize +2")
	end
end, { silent = true })
vim.keymap.set("n", "<C-Down>", function()
	if has_horizontal_split() then
		vim.cmd("resize -2")
	end
end, { silent = true })
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Remap jj to Esc
keymap("i", "jj", "<Esc>", opts)

-- go to Test
keymap("n", "gT", ":A<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
