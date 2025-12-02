# Dotfiles Setup

Configuration files for Neovim, Tmux, and Zsh.

## Prerequisites

### Required Tools

| Tool | Purpose |
|------|---------|
| git | Version control |
| zsh | Shell |
| tmux | Terminal multiplexer |
| neovim (0.9+) | Text editor |
| ripgrep | Telescope live grep |
| fd | Telescope file finder |
| lazygit | Git TUI |
| A Nerd Font | Icons in terminal/nvim/tmux |

### Optional Tools

| Tool | Purpose |
|------|---------|
| node/npm | Copilot, some LSPs |
| python3 | Python LSP, formatters |
| latexmk | LaTeX compilation (vimtex) |
| zathura | PDF viewer for LaTeX |
| xclip | Clipboard support (Linux) |

---

## Installation

### Linux (Ubuntu/Debian)

```bash
# 1. Install core packages
sudo apt update
sudo apt install -y zsh tmux git curl wget unzip ripgrep fd-find xclip

# Note: fd is installed as 'fdfind' on Debian/Ubuntu, create symlink:
sudo ln -sf $(which fdfind) /usr/local/bin/fd

# 2. Install Neovim (choose one)
# Option A: Via snap (easiest, auto-updates)
sudo snap install nvim --classic

# Option B: From GitHub releases (manual)
# Download from: https://github.com/neovim/neovim/releases
# tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# Add to PATH: export PATH="$PATH:/opt/nvim-linux64/bin"

# 3. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 5. Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# 6. Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 7. Install a Nerd Font (UbuntuSansMono)
# Download from: https://github.com/ryanoasis/nerd-fonts/releases
# Look for UbuntuSansMono.zip, extract to ~/.local/share/fonts, then run:
# fc-cache -fv

# 8. Install lazygit
# Download from: https://github.com/jesseduffield/lazygit/releases
# Extract and move to /usr/local/bin

# 9. Optional: Install Node.js (via nvm) for Copilot
# See: https://github.com/nvm-sh/nvm#installing-and-updating

# 10. Optional: Install LaTeX tools
sudo apt install -y texlive-full latexmk zathura
```

### macOS

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install core packages
brew install zsh tmux git neovim ripgrep fd lazygit

# 3. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 5. Install Powerlevel10k
brew install powerlevel10k

# 6. Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 7. Install a Nerd Font
brew install --cask font-ubuntu-sans-mono-nerd-font

# 8. Optional: Install Node.js for Copilot
brew install nvm

# 9. Optional: Install LaTeX tools
brew install --cask mactex
brew install zathura
```

---

## Copying Config Files

After cloning this repository:

```bash
# Clone the repo
git clone <repo-url> ~/.config/nvim

# Copy shell config
cp ~/.config/nvim/.zshrc ~/.zshrc

# Copy tmux config
cp ~/.config/nvim/.tmux.conf ~/.tmux.conf

# Set zsh as default shell
chsh -s $(which zsh)
```

---

## Post-Installation

### 1. Start a new terminal session

Powerlevel10k configuration wizard will run on first launch.

### 2. Install Tmux plugins

Open tmux and press `Ctrl-a + I` to install plugins via TPM.

### 3. Open Neovim

Lazy.nvim will automatically install plugins on first launch. Mason will auto-install LSPs and formatters.

### 4. Configure Copilot (optional)

```vim
:Copilot setup
```

---

## File Locations

| File | Destination |
|------|-------------|
| `.zshrc` | `~/.zshrc` |
| `.tmux.conf` | `~/.tmux.conf` |
| `init.lua` + `lua/` | `~/.config/nvim/` |

---

## Notes

- The `.tmux.conf` uses `xclip` for clipboard on Linux. On macOS it uses `pbcopy` - see comments in file.
- Tmux keybindings use Norwegian keyboard layout (ø key). Adjust if needed.
- Mason auto-installs: biome, pylsp, prettier, stylua, isort, black, pylint.
