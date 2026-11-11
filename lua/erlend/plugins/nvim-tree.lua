return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")
		local api = require("nvim-tree.api")

		-- Disable netrw (Vim's built-in file browser), nvim-tree replaces it
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		-- Open the tree on startup when no file was given, or a directory was
		vim.api.nvim_create_autocmd({ "VimEnter" }, {
			callback = function()
				local current_buffer_is_empty = vim.fn.empty(vim.fn.expand("%:p")) == 1
				local current_buffer_is_directory = vim.fn.isdirectory(vim.fn.expand("%:p")) == 1

				if current_buffer_is_empty or current_buffer_is_directory then
					api.tree.open()
				end
			end,
			group = vim.api.nvim_create_augroup("NvimTreeStartup", { clear = true }),
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		)
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

		local is_wide = false
		keymap.set("n", "<leader>ew", function()
			if is_wide then
				api.tree.resize({ width = 35 })
				is_wide = false
			else
				api.tree.resize({ width = 55 })
				is_wide = true
			end
		end, { desc = "Toggle file explorer width" })
	end,
}
