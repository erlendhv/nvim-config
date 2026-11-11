local project_checks = {
	python = {
		root_markers = { "pyproject.toml", "ruff.toml", ".git" },
		commands = {
			{ cmd = { "ruff", "check", "--output-format=concise", "." }, efm = "%f:%l:%c: %m" },
			{ cmd = { "ty", "check", "--output-format=concise", "." }, efm = "%f:%l:%c: %m" },
		},
	},
	typescript = {
		root_markers = { "tsconfig.json", "package.json" },
		commands = {
			{ cmd = { "npx", "--no", "tsc", "--noEmit", "--pretty", "false" }, efm = "%f(%l\\,%c): %m" },
			{ cmd = { "oxlint", "--format=unix" }, efm = "%f:%l:%c: %m" },
		},
	},
}
project_checks.typescriptreact = project_checks.typescript
project_checks.javascript = project_checks.typescript
project_checks.javascriptreact = project_checks.typescript

-- Show every problem in the project. For filetypes in project_checks, run CLI
-- checks in the background (their language servers only cover open files) and
-- show the results in Trouble's quickfix list. Other filetypes already get
-- whole-project diagnostics from their language server, so show those instead.
local function check_project()
	local checks = project_checks[vim.bo.filetype]
	if not checks then
		vim.lsp.buf.workspace_diagnostics()
		vim.cmd("Trouble diagnostics open")
		return
	end

	local root = vim.fs.root(0, checks.root_markers) or vim.fn.getcwd()
	local items = {}
	local remaining = #checks.commands
	vim.notify("Checking project in " .. root .. "...")

	for _, check in ipairs(checks.commands) do
		local ok, err = pcall(vim.system, check.cmd, { cwd = root, text = true }, function(result)
			vim.schedule(function()
				local lines = {}
				local output = (result.stdout or "") .. "\n" .. (result.stderr or "")
				for _, line in ipairs(vim.split(output, "\n")) do
					table.insert(lines, root .. "/" .. line)
				end
				local parsed = vim.fn.getqflist({ lines = lines, efm = check.efm }).items
				for _, item in ipairs(parsed) do
					if item.valid == 1 then
						table.insert(items, item)
					end
				end

				remaining = remaining - 1
				if remaining == 0 then
					vim.fn.setqflist({}, " ", { title = "Project check", items = items })
					vim.notify("Project check: " .. #items .. " problems")
					vim.cmd("Trouble quickfix open")
				end
			end)
		end)

		if not ok then
			vim.notify("Could not run " .. check.cmd[1] .. ": " .. err, vim.log.levels.ERROR)
			remaining = remaining - 1
		end
	end
end

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xw",
			function()
				vim.lsp.buf.workspace_diagnostics()
				vim.cmd("Trouble diagnostics toggle")
			end,
			desc = "Open trouble workspace diagnostics",
		},
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>xc", check_project, desc = "Check whole project" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},
}
