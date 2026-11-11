return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		local autopairs = require("nvim-autopairs")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")

		-- ts_config: treesitter node types per language where pairs are NOT added
		-- (e.g. no auto-closing quotes inside a Lua string)
		autopairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
				java = false,
			},
		})

		-- Add closing parenthesis after confirming a function completion
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
