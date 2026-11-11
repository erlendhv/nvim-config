# Dotfiles repo: Neovim, tmux, zsh

## Mode
Claude implements, on my instructions.

## Layout
- `init.lua` loads `lua/erlend/core/` (options, keymaps, autocmds), then `lua/erlend/lazy.lua` (lazy.nvim).
- One file per plugin in `lua/erlend/plugins/`, LSP-related ones in `lua/erlend/plugins/lsp/`. lazy imports both folders, so a new file is picked up without registering it anywhere.
- `lazy-lock.json` pins plugin versions. Commit it with plugin changes. After removing a plugin file, run `:Lazy clean`.
- Requires Neovim 0.12+ (nvim-treesitter `main` branch). Use current APIs (`vim.lsp.config`/`vim.lsp.enable`, `vim.uv`, `vim.diagnostic.config`), not deprecated ones.

## Language tooling
- Language servers and tools: the `mason_tool_installer` list in `lua/erlend/plugins/lsp/mason.lua`. mason-lspconfig's `automatic_enable` starts every Mason-installed server. Exceptions: rust-analyzer comes from rustup and is enabled explicitly in `lspconfig.lua`; Roslyn is started by roslyn.nvim (hence the `roslyn_ls` exclude).
- Per-server settings: `vim.lsp.config()` in `lua/erlend/plugins/lsp/lspconfig.lua`. LSP keymaps: the `LspAttach` autocmd in `lua/erlend/core/autocmds.lua`.
- Formatting: conform, per filetype, in `lua/erlend/plugins/formatting.lua`, on save. Filetypes not listed fall back to the language server's formatter.
- Treesitter parsers: the list in `lua/erlend/plugins/treesitter.lua`.
- Indentation: 4 spaces for python/lua/c/cpp/rust/go (`autocmds.lua`), 2 otherwise.

## Keymaps
- A Norwegian `jklø` layout replaces `hjkl` everywhere (Neovim, tmux, copy mode, completion). `K` is remapped, so LSP hover is `gk`. Leader is Space. Check `keymaps.lua` and plugin keymaps for conflicts before adding new ones.
- tmux prefix is `C-a`. Pane navigation uses vim-tmux-navigator, whose keys must stay in sync between `.tmux.conf` and `keymaps.lua`.

## Machines
- Used on macOS (Ghostty) and Linux (Ubuntu). Changes must work on both. When behavior differs, detect the OS like existing code does (`vim.fn.has("mac")` in Lua, `if-shell` + `uname` in `.tmux.conf`).
- Symlinked from `~`: `.zshrc`, `.tmux.conf`, and `claude/global-CLAUDE.md` (as `~/.claude/CLAUDE.md`). Editing them here edits the live config.
- Copied, not symlinked: `eza/theme.yml`, `lazygit-config.yml`. Re-copy after editing (see README).
- Machine-specific shell settings go in `~/.zshrc.local` (not tracked), never in `.zshrc`.
- Never extract or build binaries inside this repo.

## Documentation
- When setup steps, tools, plugins or file locations change, update `README.md`.
