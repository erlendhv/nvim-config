return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- 1. Setup the context string plugin to disable the buggy autocommand
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})

		-- 2. Setup Comment.nvim and tell it to use the context string plugin
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
