return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")
		local api = require("nvim-tree.api") -- <-- This line is crucial for 'api' to be available

		-- recommended settings from nvim-tree documentation
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
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
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

		-- Autocmd to open nvim-tree on startup
		-- This MUST be inside the 'config' function where 'api' is defined.
		vim.api.nvim_create_autocmd({ "VimEnter" }, {
			callback = function()
				-- Only open if no file is explicitly opened, or if the current buffer is a directory.
				local current_buffer_is_empty = vim.fn.empty(vim.fn.expand("%:p")) == 1
				local current_buffer_is_directory = vim.fn.isdirectory(vim.fn.expand("%:p")) == 1

				if current_buffer_is_empty or current_buffer_is_directory then
					api.tree.open()
				end
			end,
			group = vim.api.nvim_create_augroup("NvimTreeStartup", { clear = true }),
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		)
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	end,
}
