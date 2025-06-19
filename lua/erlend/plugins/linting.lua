return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "mason.nvim" }, -- Keep the dependency for good measure
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "biome" },
			typescript = { "biome" },
			javascriptreact = { "biome" },
			typescriptreact = { "biome" },
			python = { "pylint" },
		}

		-- The keymap for manual triggering is fine to set up immediately
		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		-- ** THE FIX IS HERE **
		-- We will create the autocommands that trigger automatically
		-- only AFTER Neovim has fully loaded.
		vim.api.nvim_create_autocmd("VimEnter", {
			pattern = "*",
			once = true, -- Only run this once per Neovim session
			callback = function()
				-- We create a new autocommand group here inside the callback
				local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
				vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
					group = lint_augroup,
					callback = function()
						-- Use require inside the callback just to be safe
						require("lint").try_lint()
					end,
				})
			end,
		})
	end,
}
