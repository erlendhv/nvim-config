-- File: lua/autocmds.lua
local indent_group = vim.api.nvim_create_augroup("IndentSettings", { clear = true })

local four_space_languages = { "python", "lua", "c", "cpp", "rust", "go", "csharp" }

vim.api.nvim_create_autocmd("FileType", {
	group = indent_group,
	pattern = four_space_languages,
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

-- Autocommand group for LSP settings
local lsp_group = vim.api.nvim_create_augroup("LspSettings", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(event)
		local keymap = vim.keymap
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local bufnr = event.buf

		-- Check if the server supports the features we want to map
		-- This prevents errors if a server doesn't have a specific capability
		local function has_capability(method)
			return client and client.supports_method(method)
		end

		local opts = { buffer = bufnr, silent = true }

		-- Set keymaps only for the attached buffer
		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		opts.desc = "Show line diagnostics"
		keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

		-- Specific handling for format on save, if the server supports it
		-- if has_capability("textDocument/formatting") then
		-- 	-- Create a separate autocmd for format on save
		-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 		buffer = bufnr,
		-- 		callback = function()
		-- 			vim.lsp.buf.format({ bufnr = bufnr, async = true })
		-- 		end,
		-- 	})
		-- end
	end,
})
