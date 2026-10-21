# Dotfiles Setup

Configuration files for Neovim, Tmux, and Zsh.

## Prerequisites

### Required Tools

| Tool | Purpose |
|------|---------|
| git | Version control |
| zsh | Shell |
| tmux | Terminal multiplexer |
| neovim (0.12+) | Text editor -- nvim-treesitter's `main` branch (used here) requires it |
| tree-sitter-cli | Compiles Treesitter parsers (separate from the `tree-sitter` library) |
| A C compiler | Compiles Treesitter parsers -- Xcode Command Line Tools on macOS, `build-essential` on Linux |
| ripgrep | Telescope live grep |
| fd | Telescope file finder |
| lazygit | Git TUI |
| eza | Modern ls replacement with icons |
| zoxide | Smarter cd command |
| fzf (0.48+) | Fuzzy finder -- needed for the `--zsh` shell-integration flag used below |
| A Nerd Font | Icons in terminal/nvim/tmux |

### Optional Tools

| Tool | Purpose |
|------|---------|
| node/npm (via fnm) | Some LSPs |
| python3 | Python LSP, formatters |
| dotnet SDK | Building/running C# projects (roslyn.nvim's LSP itself is installed separately via Mason) |
| latexmk | LaTeX compilation (vimtex) |
| zathura (Linux) / Skim (macOS) | PDF viewer for LaTeX |
| xclip (Linux only) | Clipboard support -- macOS uses the built-in `pbcopy`, nothing to install |
| Ghostty (macOS) | Terminal recommended for macOS -- see the keybinding note below |

---

## Installation

### Linux (Ubuntu/Debian)

```bash
# 1. Install core packages
sudo apt update
sudo apt install -y zsh tmux git curl wget unzip ripgrep fd-find xclip build-essential

# Note: fd is installed as 'fdfind' on Debian/Ubuntu, create symlink:
sudo ln -sf $(which fdfind) /usr/local/bin/fd

# 2. Install Neovim 0.12+ (choose one)
# Option A: Via snap (easiest, auto-updates)
sudo snap install nvim --classic

# Option B: From GitHub releases (manual) -- check the version first, snap
# and apt often lag behind the 0.12+ this config needs
# Download from: https://github.com/neovim/neovim/releases
# tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# Add to PATH: export PATH="$PATH:/opt/nvim-linux64/bin"

# 3. Install the tree-sitter CLI (required to compile Treesitter parsers;
# the apt package is usually too old -- prefer cargo or a prebuilt release)
# See: https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md
# Prebuilt binary (no Rust toolchain needed) -- installs to ~/.local/bin,
# which .zshrc puts on PATH:
mkdir -p ~/.local/bin
curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter
# or, if you have Rust installed: cargo install tree-sitter-cli

# 4. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 5. Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 6. Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# 7. Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 8. Install a Nerd Font (Ubuntu Mono)
# Download from: https://github.com/ryanoasis/nerd-fonts/releases
# Look for UbuntuMono.zip, extract to ~/.local/share/fonts, then run:
# fc-cache -fv

# 9. Install lazygit
# Download from: https://github.com/jesseduffield/lazygit/releases
# Extract and move to /usr/local/bin (don't run this from inside this repo's
# directory -- extracting/building there risks the binary getting committed
# by accident, as happened once before)

# 10. Install eza (modern ls replacement)
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# 11. Install zoxide (smarter cd)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# 12. Install fzf (fuzzy finder) -- 0.48 or newer for the --zsh integration flag
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-update-rc  # .zshrc already sources fzf itself, see below
# --no-update-rc means ~/.fzf/bin is never added to PATH, so link it into
# ~/.local/bin -- otherwise .zshrc's `command -v fzf` check silently skips fzf
ln -sf ~/.fzf/bin/fzf ~/.local/bin/fzf

# 13. Install python3 (usually already present, but formatters/linters need it)
sudo apt install -y python3 python3-pip

# 14. Optional: Install Node.js (via fnm) for LSPs
# --install-dir puts fnm on PATH (the default dir isn't, so .zshrc's
# `command -v fnm` check would skip it); --skip-shell stops the installer from
# appending to ~/.zshrc, which is a symlink into this repo
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
fnm install --lts && fnm default lts-latest

# 15. Optional: Install LaTeX tools
sudo apt install -y texlive-full latexmk zathura

# 16. Optional: Install the .NET SDK (for C# work, alongside roslyn.nvim)
# See: https://learn.microsoft.com/en-us/dotnet/core/install/linux
```

### macOS

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install Xcode Command Line Tools (C compiler, needed to build Treesitter
# parsers -- Neovim/Homebrew usually prompt for this automatically, but it
# can be installed explicitly)
xcode-select --install

# 3. Install core packages
brew install zsh tmux git neovim ripgrep fd lazygit eza zoxide fzf tree-sitter-cli python3 fnm

# Note: `brew install tree-sitter` alone only installs the library now --
# you need the separate `tree-sitter-cli` formula for parser compilation.

# 4. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 5. Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 6. Install Powerlevel10k
brew install powerlevel10k

# 7. Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 8. Install a Nerd Font
# NOTE: the cask is named "font-ubuntu-mono-nerd-font" (no "sans" in the
# name) -- the obvious guess is wrong and brew will fail to find a cask.
brew install --cask font-ubuntu-mono-nerd-font

# 9. Install Ghostty (recommended terminal for macOS -- see the keybinding
# note under "Post-Installation" below, it's required for tmux/nvim pane
# navigation to work correctly with this config's jklø remap)
brew install --cask ghostty

# 10. Optional: Install LaTeX tools
brew install --cask mactex
brew install --cask skim   # macOS's native PDF viewer w/ SyncTeX, used
                            # instead of zathura (which is X11/Linux-first
                            # and awkward to get working natively on macOS)

# 11. Optional: Install the .NET SDK (for C# work, alongside roslyn.nvim)
brew install --cask dotnet-sdk
```

---

## Copying Config Files

After cloning this repository:

```bash
# Clone the repo
git clone <repo-url> ~/.config/nvim

# Symlink shell and tmux config (back up any existing files first) -- with
# symlinks, a `git pull` is all it takes to bring a machine up to date
mv ~/.zshrc ~/.zshrc.bak 2>/dev/null; ln -s ~/.config/nvim/.zshrc ~/.zshrc
mv ~/.tmux.conf ~/.tmux.conf.bak 2>/dev/null; ln -s ~/.config/nvim/.tmux.conf ~/.tmux.conf

# Machine-specific shell settings (aliases, CUDA paths, etc.) go in
# ~/.zshrc.local, which .zshrc sources at the end and git never sees
touch ~/.zshrc.local

# Copy eza theme
mkdir -p ~/.config/eza
cp ~/.config/nvim/eza/theme.yml ~/.config/eza/theme.yml

# Copy lazygit config -- note the destination differs by OS:
#   Linux:  ~/.config/lazygit/config.yml
#   macOS:  ~/Library/Application Support/lazygit/config.yml
# (run `lazygit --print-config-dir` to confirm the exact path for your setup)
mkdir -p "$(lazygit --print-config-dir)"
cp ~/.config/nvim/lazygit-config.yml "$(lazygit --print-config-dir)/config.yml"

# Set zsh as default shell
chsh -s $(which zsh)
```

---

## Post-Installation

### 1. macOS: configure Ghostty's keybinding translation

This config remaps `hjkl` to `jklø` (matching a Norwegian keyboard) throughout Neovim and tmux. On Linux, `Alt+j/k/l/ø` reaches the terminal directly as normal escape codes. On macOS, `Cmd` can't be sent as a terminal escape code and `ø` has historically been buggy in terminal emulators, so Ghostty is configured to translate `Cmd+j/k/l/ø` into standard `Meta+h/j/k/l` before tmux or Neovim ever see it -- both then just use the normal hjkl scheme (this is already handled automatically in `.tmux.conf` and `keymaps.lua` based on OS detection; this step only concerns the terminal-level translation).

Add to Ghostty's config (`~/.config/ghostty/config` on macOS):

```
# Map Cmd + j/k/l/ø to send Meta/Alt signals to the terminal
keybind = cmd+j=text:\x1bh
keybind = cmd+k=text:\x1bj
keybind = cmd+l=text:\x1bk
keybind = cmd+ø=text:\x1bl

# Give back the normal macOS Option key (for typing {}, [], etc.) instead of
# having it act as Alt/Meta
macos-option-as-alt = false
```

### 2. Start a new terminal session

Powerlevel10k configuration wizard will run on first launch.

### 3. Install Tmux plugins

Open tmux and press `Ctrl-a + I` to install plugins via TPM.

### 4. Open Neovim

Lazy.nvim will automatically install plugins on first launch. Mason will auto-install LSPs and formatters. On first parser install, `nvim-treesitter` will compile several Treesitter parsers -- this requires the `tree-sitter-cli` and C compiler from the Prerequisites step above; without them you'll see `tree-sitter build` errors during `:TSUpdate`/first launch.

### 5. C#/.NET work (optional)

`roslyn.nvim` manages its own copy of the Roslyn language server via Mason (installed automatically as `roslyn-language-server` the first time you open a `.cs` file) -- you don't need to install it separately. You do need the .NET SDK itself installed system-wide to actually build/run/restore your projects (`dotnet build`, `dotnet run`, etc.).

---

## File Locations

| File | Destination |
|------|-------------|
| `.zshrc` | `~/.zshrc` (symlink) |
| `.tmux.conf` | `~/.tmux.conf` (symlink) |
| -- | `~/.zshrc.local` (machine-specific, not in repo) |
| `init.lua` + `lua/` | `~/.config/nvim/` |
| `eza/theme.yml` | `~/.config/eza/theme.yml` |
| `lazygit-config.yml` | `~/.config/lazygit/config.yml` (Linux) or `~/Library/Application Support/lazygit/config.yml` (macOS) |

---

## Notes

- `.tmux.conf` detects the OS automatically (via `if-shell` + `uname`) for both the clipboard command (`pbcopy` on macOS, `xclip` on Linux) and the tmux-navigator key scheme -- no manual editing needed after cloning.
- Tmux/Neovim pane navigation and cursor movement use a Norwegian-keyboard-inspired `jklø` remap. The *physical* key you press is the same on both OSes (`Alt+j/k/l/ø` on Linux, `Cmd+j/k/l/ø` on macOS via Ghostty's translation, see Post-Installation above) -- `keymaps.lua` and `.tmux.conf` both detect the OS and wire up the resulting escape codes (`M-h/j/k/l` on macOS, `M-j/k/l/ø` on Linux) to match.
- Mason auto-installs: biome, pylsp, prettier, stylua, isort, black, pylint. `roslyn-language-server` installs automatically the first time you open a `.cs` file.
- zoxide uses `j` command instead of `z` (e.g., `j projects` to jump to a directory).
- fzf uses custom vim-style bindings: `Ctrl+k` = down, `Ctrl+l` = up.
- Completion menu navigation uses `Ctrl+jklø` for vim-style movement.
- Don't extract/build release binaries (e.g. lazygit) from inside this repo's directory -- it's happened before that one got committed by accident. If you ever need to, do it in a scratch directory instead.
