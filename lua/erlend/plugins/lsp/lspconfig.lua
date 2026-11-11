return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				prefix = "●",
			},
			underline = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "\u{f057} ",
					[vim.diagnostic.severity.WARN] = "\u{f071} ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = "\u{f05a} ",
				},
			},
			update_in_insert = false,
			severity_sort = true,
		})

		vim.cmd([[
			hi! DiagnosticUnderlineError guisp=#E06C75 gui=undercurl
			hi! DiagnosticUnderlineWarn  guisp=#E5C07B gui=undercurl
			hi! DiagnosticUnderlineInfo  guisp=#61AFEF gui=undercurl
			hi! DiagnosticUnderlineHint  guisp=#C678DD gui=undercurl
		]])

		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Note: mason-lspconfig's `setup({ handlers = ... })` option (the old way of
		-- customizing servers) is no longer read by this version of the plugin -- it
		-- auto-enables every installed server straight via vim.lsp.enable(). Per-server
		-- customization now goes through vim.lsp.config() instead, which merges into
		-- whatever config that server ends up starting with.

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
				},
			},
		})

		vim.lsp.config("ty", {
			settings = {
				ty = {
					diagnosticMode = "workspace",
				},
			},
		})

		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					check = { command = "clippy" },
				},
			},
		})
		vim.lsp.enable("rust_analyzer")

		-- automatic_enable (with the roslyn_ls exclude) is set once in mason.lua,
		-- which loads before this file does -- see the comment there.
		mason_lspconfig.setup({})
	end,
}
