return {
	"lervag/vimtex",
	lazy = false,
	-- We lazy-load on the 'tex' filetype
	ft = { "tex", "latex", "bib" },
	init = function()
		-- This is the minimal config to get Zathura working
		vim.g.vimtex_view_method = "zathura"

		-- This line enables continuous compilation
		-- It will start 'latexmk -pvc' when you start compilation
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_leader_key = " "
		vim.g.vimtex_compiler_latexmk = {
			options = {
				"-shell-escape",
			},
			out_dir = "build",
		}

		-- Optional: Disable the conceal feature if you don't like it
		-- vim.g.vimtex_conceal_enabled = 0
	end,
}
