return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				-- "cssls",
				-- "jsonls",
				"biome",
				-- "ts_ls",
				-- "csharp_ls",
				"pylsp",
			},
			automatic_enable = {
				-- roslyn.nvim already starts and manages the roslyn-language-server
				-- binary (client name "roslyn"). Without this exclude, mason-lspconfig
				-- auto-attaches it a second time as "roslyn_ls" (nvim-lspconfig's
				-- built-in config for the same binary), duplicating every diagnostic.
				-- This has to be set here rather than in lspconfig.lua's setup() call,
				-- since this file loads eagerly and lspconfig.lua only loads on
				-- BufReadPre -- by then vim.lsp.enable("roslyn_ls") would already have
				-- run once and there's no un-enabling it after the fact.
				exclude = { "roslyn_ls" },
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- "csharp_ls",
				"biome",
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
			},
		})
	end,
}
