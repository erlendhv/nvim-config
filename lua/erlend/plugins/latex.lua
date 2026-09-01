return {
	"lervag/vimtex",
	lazy = false,
	-- We lazy-load on the 'tex' filetype
	ft = { "tex", "latex", "bib" },
	init = function()
		-- Zathura (Linux) is X11/GTK-based and awkward to run on macOS, so use
		-- Skim there instead -- macOS's native PDF viewer with SyncTeX support.
		vim.g.vimtex_view_method = vim.fn.has("mac") == 1 and "skim" or "zathura"

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
