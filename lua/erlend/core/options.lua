vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping
-- opt.linebreak = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "1"

-- set foldmethod after ftplugins (they often override it)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
	end,
})

-- fold highlight (subtle pink) - set after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "#f7768e" })
	end,
})
