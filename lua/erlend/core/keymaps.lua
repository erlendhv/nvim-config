-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

local modes = { "n", "v", "o" }
local opts = { silent = true }

-- jklø movement (Norwegian layout) instead of hjkl
keymap.set(modes, "j", "h", opts)
keymap.set(modes, "k", "j", opts)
keymap.set(modes, "l", "k", opts)
keymap.set(modes, "ø", "l", opts)

-- Remap the original functions of j, k, l
keymap.set(modes, "h", "j", opts)
keymap.set(modes, "J", "k", opts)
keymap.set(modes, "K", "l", opts)

-- Screen top/bottom and join lines, moved off J/L/H by the jklø remap above
keymap.set("n", "J", "H", { silent = true, desc = "Move to top of screen" })
keymap.set("n", "Ø", "L", { silent = true, desc = "Move to bottom of screen" })
keymap.set("n", "H", "J", { silent = true, desc = "Join lines" })

keymap.set({ "n", "i" }, "<C-s>", "<Cmd>w<CR>", { silent = true, desc = "Save file" })

-- Accept capitalized quit commands (typo-proofing for :Q, :Qa)
vim.cmd("command! Q q")
vim.cmd("command! Qa qa")
vim.cmd("command! QA qa")
vim.cmd("command! QAll qa")

keymap.set("i", "<A-BS>", "<C-w>", { silent = true, desc = "Delete word before cursor" })
keymap.set("i", "<C-r>", "<C-o><C-r>", { desc = "Redo" })

-- Highlight all matches of the word under cursor without jumping (* jumps, N jumps back)
keymap.set("n", "<C-f>", "*N", { silent = true, desc = "Search word under cursor" })

keymap.set("n", "<leader>rc", function()
	local current_word = vim.fn.expand("<cword>")
	if current_word == "" then
		print("No word under cursor.")
		return
	end
	local new_word = vim.fn.input("Replace '" .. current_word .. "' with: ", current_word)
	if new_word ~= "" then
		local pattern = vim.fn.escape(current_word, "/\\")
		local replacement = vim.fn.escape(new_word, "/\\&~")
		local cmd = string.format("%%s/\\V\\<%s\\>/%s/gc", pattern, replacement)
		vim.cmd(cmd)
	end
end, { desc = "Replace word under cursor (global with confirmation)" })

-- Disable the default keybindings first
vim.g.tmux_navigator_no_mappings = 1

-- Tmux-navigator keys differ by OS:
-- - macOS: Ghostty translates Cmd+j/k/l/ø into standard Meta+h/j/k/l before
--   the terminal ever sees it (Cmd and ø can't be sent as clean escape codes
--   on Mac), so nvim/tmux just use the normal hjkl scheme here.
-- - Linux: Alt+j/k/l/ø reaches the terminal directly with no translation
--   layer, so the jklø remap has to happen here instead.
-- .tmux.conf's @vim_navigator_mapping_* has to stay in sync with whichever
-- of these is active.
if vim.fn.has("mac") == 1 then
	keymap.set("n", "<M-h>", ":<C-U>TmuxNavigateLeft<cr>", opts)
	keymap.set("n", "<M-j>", ":<C-U>TmuxNavigateDown<cr>", opts)
	keymap.set("n", "<M-k>", ":<C-U>TmuxNavigateUp<cr>", opts)
	keymap.set("n", "<M-l>", ":<C-U>TmuxNavigateRight<cr>", opts)
else
	keymap.set("n", "<A-j>", ":<C-U>TmuxNavigateLeft<cr>", opts)
	keymap.set("n", "<A-k>", ":<C-U>TmuxNavigateDown<cr>", opts)
	keymap.set("n", "<A-l>", ":<C-U>TmuxNavigateUp<cr>", opts)
	keymap.set("n", "<A-ø>", ":<C-U>TmuxNavigateRight<cr>", opts)
end

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>tc", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

keymap.set("n", "<leader>rr", "<cmd>checktime<cr>", { desc = "Reload files" })

-- Wrap long lines and make jklø-style movement follow screen lines instead of
-- real lines, for the current buffer only
local function toggle_visual_wrap_local()
	local buffer_opts = { buffer = 0 }

	if vim.b.visual_wrap then
		vim.opt_local.wrap = false
		vim.opt_local.linebreak = false
		keymap.del(modes, "k", buffer_opts)
		keymap.del(modes, "l", buffer_opts)
		keymap.del(modes, "h", buffer_opts)
		keymap.del("n", "J", buffer_opts)
		vim.b.visual_wrap = false
		print("Visual Wrap Mode: OFF")
	else
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		keymap.set(modes, "k", "gj", { buffer = 0, desc = "Visual Down" })
		keymap.set(modes, "l", "gk", { buffer = 0, desc = "Visual Up" })
		keymap.set(modes, "h", "gj", { buffer = 0, desc = "Visual Down" })
		keymap.set("n", "J", "gk", { buffer = 0, desc = "Visual Up" })
		vim.b.visual_wrap = true
		print("Visual Wrap Mode: ON")
	end
end

keymap.set("n", "<leader>wl", toggle_visual_wrap_local, { desc = "Toggle Visual Wrap (Current Buffer)" })
