return {
	"nvim-treesitter/nvim-treesitter",
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
			"prisma",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c",
			"cpp",
			"c_sharp",
			"cmake",
			"python",
			"sql",
			"java",
			"julia",
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
