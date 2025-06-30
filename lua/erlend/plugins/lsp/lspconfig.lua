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

		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Use the default capabilities from cmp-nvim-lsp
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- -- Setup signs for diagnostics
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup({
			handlers = {
				-- The default handler for all servers
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						-- NO on_attach needed here, the autocmd handles it!
					})
				end,

				-- You can still have custom setups for specific servers
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								completion = { callSnippet = "Replace" },
							},
						},
					})
				end,
				["ts_ls"] = function()
					lspconfig["ts_ls"].setup({
						capabilities = capabilities,
						-- This is the key: on_attach function to disable formatting
						on_attach = function(client, bufnr)
							-- Disable formatting from ts_ls because we want to use Biome for it
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end,
					})
				end,
			},
		})
	end,
}
