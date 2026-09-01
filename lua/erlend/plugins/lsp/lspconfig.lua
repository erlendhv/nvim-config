-- File: lua/erlend/plugins/lspconfig.lua
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- ++ ADD THIS ENTIRE SECTION AT THE TOP ++
		-- ===================================================================
		-- CONFIGURE DIAGNOSTIC DISPLAYS
		-- ===================================================================
		vim.diagnostic.config({
			-- Show diagnostics as virtual text (errors/warnings at the end of the line)
			virtual_text = {
				spacing = 4, -- Add some space between the code and the virtual text
				prefix = "●", -- Can be '●', '▎', 'x', or any character you like
			},

			-- Show squiggly underlines for diagnostics.
			underline = true,

			-- Show signs in the gutter (you already have this, but it's good to have it here).
			signs = true,

			-- Don't update diagnostics in insert mode, for better performance.
			-- The diagnostics will update when you exit insert mode.
			update_in_insert = false,

			-- Sort diagnostics by severity. This will show errors before warnings.
			severity_sort = true,
		})

		-- Optional: Customize the appearance of the underlines.
		-- Some colorschemes might not define these well. These are good defaults.
		vim.cmd([[
			hi! DiagnosticUnderlineError guisp=#E06C75 gui=undercurl
			hi! DiagnosticUnderlineWarn  guisp=#E5C07B gui=undercurl
			hi! DiagnosticUnderlineInfo  guisp=#61AFEF gui=undercurl
			hi! DiagnosticUnderlineHint  guisp=#C678DD gui=undercurl
		]])

		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Use the default capabilities from cmp-nvim-lsp
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- -- Setup signs for diagnostics
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Note: mason-lspconfig's `setup({ handlers = ... })` option (the old way of
		-- customizing servers) is no longer read by this version of the plugin -- it
		-- auto-enables every installed server straight via vim.lsp.enable(). Per-server
		-- customization now goes through vim.lsp.config() instead, which merges into
		-- whatever config that server ends up starting with.

		-- Applies to every server ("*" is a wildcard base config)
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		vim.lsp.config("ts_ls", {
			-- Disable formatting from ts_ls because we want to use Biome for it
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})

		-- automatic_enable (with the roslyn_ls exclude) is set once in mason.lua,
		-- which loads before this file does -- see the comment there.
		mason_lspconfig.setup({})
	end,
}
