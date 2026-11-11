return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})

		-- Make Neovim's built-in gc/gcc use the commentstring for the language
		-- at the cursor (e.g. {/* */} inside JSX)
		local get_option = vim.filetype.get_option
		vim.filetype.get_option = function(filetype, option)
			if option == "commentstring" then
				local commentstring = require("ts_context_commentstring.internal").calculate_commentstring()
				if commentstring then
					return commentstring
				end
			end
			return get_option(filetype, option)
		end
	end,
}
