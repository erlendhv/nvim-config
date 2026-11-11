return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	-- the "main" branch rewrite does not support lazy-loading
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"windwp/nvim-ts-autotag",
			-- Initialize autotag directly here instead of inside treesitter
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		},
	},
	config = function()
		-- ensure these language parsers are installed
		-- (no more "auto_install on open" like the old plugin - unlisted languages
		-- won't get highlighting until added here)
		local ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c_sharp",
			"python",
			"rust",
		}
		require("nvim-treesitter").install(ensure_installed)

		-- enable highlighting and indentation for any filetype with an installed parser
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				local has_parser = pcall(vim.treesitter.start)
				if has_parser then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
