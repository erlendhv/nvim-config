-- set leader key to space
vim.g.mapleader = " "

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

-- Save file in both normal and insert mode with Ctrl+S
vim.keymap.set({ "n", "i" }, "<C-s>", "<Cmd>w<CR>", opts)

-- Disable the default keybindings first
vim.g.tmux_navigator_no_mappings = 1

-- Custom keybindings using your preferred keys (ctrl + jklp)
-- vim.api.nvim_set_keymap("n", "<M-j>", ":TmuxNavigateLeft<CR>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<M-k>", ":TmuxNavigateDown<CR>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<M-l>", ":TmuxNavigateUp<CR>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<M-ø>", ":TmuxNavigateRight<CR>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<M-p>", ":TmuxNavigateRight<CR>", { silent = true, noremap = true })
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

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
