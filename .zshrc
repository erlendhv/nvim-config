# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# We use robbyrussell as fallback, but powerlevel10k is sourced at the bottom
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# Tmux Auto-Start
# ============================================================================
# Start tmux when the terminal is started
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ (screen|tmux) ]] && [ -z "$TMUX" ]; then
    [ -z "$(tmux list-sessions 2>/dev/null)" ] && exec tmux || echo "Tmux session exists. Start manually if needed."
fi

# ============================================================================
# OS-Specific Configuration
# ============================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific settings
    # Powerlevel10k installed via Homebrew
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
else
    # Linux specific settings
    # Powerlevel10k cloned to home directory
    source ~/powerlevel10k/powerlevel10k.zsh-theme

    # Enable color support of ls
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # Colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    # Neovim path (if installed to /opt)
    [ -d "/opt/nvim-linux64/bin" ] && export PATH="$PATH:/opt/nvim-linux64/bin"

    # CUDA paths (uncomment if using CUDA)
    # export PATH=/usr/local/cuda-12.6/bin:$PATH
    # export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64:$LD_LIBRARY_PATH

    # Local bin path (for tools like zoxide)
    export PATH="$HOME/.local/bin:$PATH"
fi

# ============================================================================
# Aliases
# ============================================================================
# eza aliases (modern ls replacement with icons and git integration)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l -a --icons --git --header --group-directories-first'
alias la='eza -A --icons --group-directories-first'
alias l='eza --icons --classify --group-directories-first'

# Alert alias for long running commands (Linux with notify-send)
# Usage: sleep 10; alert
if command -v notify-send &> /dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history 1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Load additional aliases from ~/.bash_aliases if it exists
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# ============================================================================
# Custom Functions
# ============================================================================
# Run Python script with virtual environment's Python as sudo
spython() {
    VENV_PATH=$(find . -type d -name 'bin' -exec test -e '{}/python' \; -print -quit)
    if [ -z "$VENV_PATH" ]; then
        echo "No virtual environment found."
        return 1
    fi
    sudo "$VENV_PATH/python" "$@"
}

# ============================================================================
# Development Tools
# ============================================================================
# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Julia (via juliaup) - uncomment if using Julia
# case ":$PATH:" in
#     *:$HOME/.juliaup/bin:*) ;;
#     *) export PATH="$HOME/.juliaup/bin${PATH:+:${PATH}}" ;;
# esac

# ============================================================================
# fzf (Fuzzy Finder)
# ============================================================================
# Custom vim-style bindings (ctrl+k=down, ctrl+l=up)
export FZF_DEFAULT_OPTS="--bind 'ctrl-k:down,ctrl-l:up'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================================================
# zoxide (Smarter cd)
# ============================================================================
# Use 'j' command instead of 'z' for jumping to directories
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd j)"
fi

# ============================================================================
# Completion Menu Navigation
# ============================================================================
# Vim-style navigation in completion menus (Ctrl + jklø)
zmodload zsh/complist
bindkey -M menuselect '^j' backward-char        # Ctrl+j = left
bindkey -M menuselect '^k' down-line-or-history # Ctrl+k = down
bindkey -M menuselect '^l' up-line-or-history   # Ctrl+l = up
bindkey -M menuselect ';' forward-char          # Ctrl+ø (produces ;) = right

# ============================================================================
# Powerlevel10k Configuration
# ============================================================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
