-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

-- Define the modes you want to map to
local modes = { "n", "v", "o" } -- Normal, Visual, and Operator-pending modes

-- Function to map keys in multiple modes
local function map_in_modes(modes, lhs, rhs, opts)
	for _, mode in ipairs(modes) do
		vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
	end
end
--
-- -- Options for non-recursive and silent mapping
local opts = { noremap = true, silent = true }

-- Remap movement keys
map_in_modes(modes, "j", "h", opts)
map_in_modes(modes, "k", "j", opts)
map_in_modes(modes, "l", "k", opts)
map_in_modes(modes, "ø", "l", opts)

-- Remap the original functions of j, k, l
map_in_modes(modes, "h", "j", opts)
map_in_modes(modes, "J", "k", opts)
map_in_modes(modes, "K", "l", opts)

-- Remap J to H (move to top of screen)
vim.keymap.set("n", "J", "H", { noremap = true, silent = true })

-- Remap L (move to bottom of screen) to Ø
vim.keymap.set("n", "Ø", "L", { noremap = true, silent = true, desc = "Move to bottom of screen" })

-- Remap H to J with one space in between (join lines)
vim.keymap.set("n", "H", "J", { noremap = true, silent = true })

-- Save file in both normal and insert mode with Ctrl+S
vim.keymap.set({ "n", "i" }, "<C-s>", "<Cmd>w<CR>", opts)

-- Make various capitalized quit commands work
vim.cmd("command! Q q")
vim.cmd("command! Qa qa")
vim.cmd("command! QA qa")
vim.cmd("command! QAll qa")

-- Deleting word before cursor in insert mode with Alt+backspace
vim.keymap.set("i", "<A-BS>", "<C-w>", opts)

-- Map Ctrl+z to undo in insert mode
-- vim.keymap.set("i", "<C-z>", "<C-o>u", { noremap = true, desc = "Undo in insert mode" })

-- Map Ctrl+r to redo in insert mode
vim.keymap.set("i", "<C-r>", "<C-o><C-r>", { noremap = true, desc = "Redo in insert mode" })

vim.keymap.set("n", "<C-f>", function()
	-- Get the current word under cursor
	local current_word = vim.fn.expand("<cword>")

	-- Execute the search using * command (which searches for the word under cursor)
	-- but without moving to the next match
	vim.cmd([[execute "normal! *N"]])

	-- Optional: Highlight all matches
	vim.opt.hlsearch = true
end, { noremap = true, silent = true, desc = "Search word under cursor" })

-- Remap search and replace for the word under cursor
vim.keymap.set("n", "<leader>rc", function()
	local current_word = vim.fn.expand("<cword>")
	if current_word == "" then
		print("No word under cursor.")
		return
	end
	local new_word = vim.fn.input("Replace '" .. current_word .. "' with: ", current_word)
	-- Proceed only if the user did not cancel the input (by pressing Esc)
	-- and the new word is not empty.
	if new_word and new_word ~= "" then
		-- Note the added "%" as the first argument to string.format
		local cmd = string.format("%%s/\\<%s\\>/%s/gc", current_word, new_word)
		vim.cmd(cmd)
	end
end, { desc = "Replace word under cursor (global with confirmation)" })

-- Disable the default keybindings first
vim.g.tmux_navigator_no_mappings = 1

-- Custom keybindings using your preferred keys (ctrl + jklp)
vim.keymap.set("n", "<A-j>", ":<C-U>TmuxNavigateLeft<cr>", opts)
vim.keymap.set("n", "<A-k>", ":<C-U>TmuxNavigateDown<cr>", opts)
vim.keymap.set("n", "<A-l>", ":<C-U>TmuxNavigateUp<cr>", opts)
vim.keymap.set("n", "<A-ø>", ":<C-U>TmuxNavigateRight<cr>", opts)

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>tc", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

vim.keymap.set("n", "<leader>rr", "<cmd>checktime<cr>", { desc = "Reload files" })

vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })

-- This function toggles a buffer-local "visual wrap" mode
local function toggle_visual_wrap_local()
	local bufnr = vim.api.nvim_get_current_buf()
	local modes = { "n", "v", "o" } -- Normal, Visual, Operator-pending

	-- Check the buffer-local 'wrap' setting
	if vim.opt_local.wrap:get() == true then
		--
		-- STATE IS ON: Turn it OFF
		--
		vim.opt_local.wrap = false
		vim.opt_local.linebreak = false
		print("Visual Wrap Mode: OFF")

		-- Delete the buffer-local visual mappings to restore global defaults
		for _, mode in ipairs(modes) do
			vim.keymap.del(mode, "k", { buffer = bufnr })
			vim.keymap.del(mode, "l", { buffer = bufnr })
			vim.keymap.del(mode, "h", { buffer = bufnr })
		end
		vim.keymap.del("n", "J", { buffer = bufnr })
	else
		--
		-- STATE IS OFF: Turn it ON
		--
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		print("Visual Wrap Mode: ON")

		-- Create new buffer-local mappings for visual movement
		-- These will override your global (logical) mappings for this buffer only
		local opts = { buffer = bufnr, remap = false }

		for _, mode in ipairs(modes) do
			opts.desc = "Visual Down"
			vim.keymap.set(mode, "k", "gj", opts) -- Your 'k' (down) becomes 'gj'
			opts.desc = "Visual Up"
			vim.keymap.set(mode, "l", "gk", opts) -- Your 'l' (up) becomes 'gk'
			opts.desc = "Visual Down"
			vim.keymap.set(mode, "h", "gj", opts) -- Your 'h' (down) becomes 'gj'
		end

		-- Your 'J' (up) becomes 'gk' (only in Normal mode)
		opts.desc = "Visual Up"
		vim.keymap.set("n", "J", "gk", opts)
	end
end

-- Create the keymap to trigger the toggle function
vim.keymap.set("n", "<leader>wl", toggle_visual_wrap_local, { desc = "Toggle Visual Wrap (Current Buffer)" })
