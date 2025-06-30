-- File: lua/erlend/plugins/linting.lua
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- This is the correct way to configure nvim-lint's global settings.
		lint.log_level = vim.diagnostic.severity.WARN

		-- Your linter definition is perfect and remains unchanged.
		lint.linters.biome = {
			cmd = "biome",
			args = { "check", "--no-errors-on-unmatched", "--reporter=json", "--stdin-filename", "%f", "-" },
			stdin = true,
			stream = "stdout",
			success_exit_codes = { 0, 1 },
			ignore_stderr = true,
		}

		-- The rest of your configuration remains the same.
		lint.linters_by_ft = {
			javascript = { "biome" },
			typescript = { "biome" },
			javascriptreact = { "biome" },
			typescriptreact = { "biome" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
