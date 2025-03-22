#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
  echo -e "${BLUE}==>${NC} $1"
}

print_success() {
  echo -e "${GREEN}==>${NC} $1"
}

print_error() {
  echo -e "${RED}==>${NC} $1"
}

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    print_message "Detected macOS"
  elif [[ -f /etc/arch-release ]]; then
    OS="arch"
    print_message "Detected Arch Linux"
  elif grep -q Microsoft /proc/version; then
    OS="wsl"
    print_message "Detected WSL"
  elif [[ -f /etc/debian_version ]]; then
    OS="debian"
    print_message "Detected Debian/Ubuntu"
  else
    print_error "Unsupported OS"
    exit 1
  fi
}

# Install package managers
install_package_managers() {
  print_message "Installing package managers..."

  case $OS in
  macos)
    # Install Homebrew if not installed
    if ! command -v brew &>/dev/null; then
      print_message "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      # Add Homebrew to PATH
      if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    else
      print_message "Homebrew already installed. Updating..."
      brew update
    fi
    ;;

  arch)
    # Update pacman
    print_message "Updating pacman packages..."
    sudo pacman -Syu --noconfirm

    # Install yay if not installed
    if ! command -v yay &>/dev/null; then
      print_message "Installing yay (AUR helper)..."
      sudo pacman -S --needed --noconfirm git base-devel
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay
      makepkg -si --noconfirm
      cd -
      rm -rf /tmp/yay
    fi
    ;;

  wsl | debian)
    # Update apt
    print_message "Updating apt packages..."
    sudo apt update && sudo apt upgrade -y

    # Install essential build tools
    print_message "Installing build-essential..."
    sudo apt install -y build-essential
    ;;
  esac
}

# Install ZSH and Oh-My-ZSH
install_zsh() {
  print_message "Setting up ZSH..."

  case $OS in
  macos)
    brew install zsh
    ;;
  arch)
    sudo pacman -S --noconfirm zsh
    ;;
  wsl | debian)
    sudo apt install -y zsh
    ;;
  esac

  # Install Oh-My-ZSH if not installed
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_message "Installing Oh My ZSH..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Install Starship prompt if not installed
  if ! command -v starship &>/dev/null; then
    print_message "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    # Add starship init to .zshrc if not already there
    if ! grep -q "starship init zsh" "$HOME/.zshrc"; then
      echo 'eval "$(starship init zsh)"' >>"$HOME/.zshrc"
    fi
  fi

  # Set ZSH as default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    print_message "Setting ZSH as default shell..."
    chsh -s "$(which zsh)"
  fi
}

# Install programming languages
install_languages() {
  # Install Go
  install_golang

  # Install Node.js and pnpm
  install_node

  # Install Python
  install_python

  # Install Ruby
  # install_ruby
}

# Install Golang
install_golang() {
  print_message "Installing Go..."

  case $OS in
  macos)
    brew install go
    ;;
  arch)
    sudo pacman -S --noconfirm go
    ;;
  wsl | debian)
    if ! command -v go &>/dev/null; then
      print_message "Installing Golang..."
      GO_VERSION="1.21.5" # Update this to the latest stable version
      wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
      sudo rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
      rm "go${GO_VERSION}.linux-amd64.tar.gz"
    fi
    ;;
  esac

  # Set up GOPATH
  mkdir -p "$HOME/go/{bin,src,pkg}"

  # Add go to PATH if not already
  if ! grep -q "GOPATH" "$HOME/.zshrc"; then
    echo 'export GOPATH=$HOME/go' >>"$HOME/.zshrc"
    echo 'export GOBIN=$GOPATH/bin' >>"$HOME/.zshrc"
    echo 'export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin' >>"$HOME/.zshrc"
  fi
}

# Install Node.js and pnpm
install_node() {
  print_message "Installing Node.js and pnpm..."

  # Install nvm for Node.js version management
  if [ ! -d "$HOME/.nvm" ]; then
    print_message "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

    # Add nvm to shell
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  else
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi

  # Install latest LTS version of Node.js
  print_message "Installing Node.js LTS..."
  nvm install --lts
  nvm use --lts

  # Install pnpm
  print_message "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -

  # Add pnpm to PATH
  export PNPM_HOME="$HOME/.local/share/pnpm"
  if ! grep -q "PNPM_HOME" "$HOME/.zshrc"; then
    echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >>"$HOME/.zshrc"
    echo 'export PATH="$PNPM_HOME:$PATH"' >>"$HOME/.zshrc"
  fi
}

# Install Python and tools
install_python() {
  print_message "Installing Python..."

  case $OS in
  macos)
    brew install python pyenv
    ;;
  arch)
    sudo pacman -S --noconfirm python python-pip pyenv
    ;;
  wsl | debian)
    sudo apt install -y python3 python3-pip python3-venv
    # Install pyenv
    if ! command -v pyenv &>/dev/null; then
      curl https://pyenv.run | bash
    fi
    ;;
  esac

  # Set up pyenv
  if ! grep -q "pyenv" "$HOME/.zshrc"; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >>"$HOME/.zshrc"
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >>"$HOME/.zshrc"
    echo 'eval "$(pyenv init -)"' >>"$HOME/.zshrc"
  fi

  # Install common Python packages
  pip3 install --user pipx
  pipx ensurepath
  pipx install poetry
}

# Install Ruby and rbenv
install_ruby() {
  print_message "Installing Ruby..."

  case $OS in
  macos)
    brew install ruby rbenv ruby-build
    ;;
  arch)
    sudo pacman -S --noconfirm ruby
    yay -S --noconfirm rbenv ruby-build
    ;;
  wsl | debian)
    sudo apt install -y ruby-full
    # Install rbenv
    if ! command -v rbenv &>/dev/null; then
      git clone https://github.com/rbenv/rbenv.git ~/.rbenv
      git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
    ;;
  esac

  # Configure rbenv
  if ! grep -q "rbenv" "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >>"$HOME/.zshrc"
    echo 'eval "$(rbenv init -)"' >>"$HOME/.zshrc"
  fi

  # Source rbenv for the current session
  export PATH="$HOME/.rbenv/bin:$PATH"
  if command -v rbenv &>/dev/null; then
    eval "$(rbenv init -)"
    # Install latest stable Ruby
    RUBY_VERSION=$(rbenv install -l | grep -v - | tail -1)
    rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
  fi
}

# Install Neovim
install_neovim() {
  print_message "Installing Neovim..."

  case $OS in
  macos)
    brew install neovim
    ;;
  arch)
    sudo pacman -S --noconfirm neovim
    ;;
  wsl | debian)
    # Install from PPA for latest version
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
    ;;
  esac
}

# Install development tools
install_dev_tools() {
  print_message "Installing development tools..."

  case $OS in
  macos)
    brew install git tmux fzf ripgrep fd eza bat lazygit
    ;;
  arch)
    sudo pacman -S --noconfirm git tmux fzf ripgrep fd eza bat
    yay -S --noconfirm lazygit
    ;;
  wsl | debian)
    sudo apt install -y git tmux fzf ripgrep fd-find bat

    # Install eza (formerly exa)
    if ! command -v eza &>/dev/null; then
      sudo mkdir -p /etc/apt/keyrings
      wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/eza.gpg
      echo "deb [signed-by=/etc/apt/keyrings/eza.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/eza.list
      sudo chmod 644 /etc/apt/keyrings/eza.gpg
      sudo apt update
      sudo apt install -y eza
    fi

    # Install lazygit
    if ! command -v lazygit &>/dev/null; then
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf lazygit.tar.gz lazygit
      sudo install lazygit /usr/local/bin
      rm lazygit lazygit.tar.gz
    fi
    ;;
  esac
}

# Configure Git
configure_git() {
  print_message "Configuring Git..."

  read -p "Enter your Git user name: " GIT_USERNAME
  read -p "Enter your Git email: " GIT_EMAIL

  git config --global user.name "$GIT_USERNAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch main
  git config --global core.editor nvim
  git config --global pull.rebase false

  print_success "Git configured with user: $GIT_USERNAME and email: $GIT_EMAIL"
}

# Setup dotfiles
setup_dotfiles() {
  print_message "Setting up dotfiles..."

  # Create aliases
  mkdir -p "$HOME/.config/zsh"

  # Create aliases file
  cat >"$HOME/.config/zsh/aliases.zsh" <<'EOL'
# File system
alias ls='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias n='nvim'
alias g='git'
alias d='docker'
alias lzg='lazygit'

# Git
alias gs='git status'
alias gcm='git commit -m'
alias gaa='git add --all'
alias gcam='git commit -a -m'
alias gp='git push'
alias gl="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias shipit="git push --set-upstream origin HEAD"

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"
EOL

  # Create exports file
  cat >"$HOME/.config/zsh/exports.zsh" <<'EOL'
# PATH exports
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
EOL

  # Add source commands to .zshrc if not there
  if ! grep -q "source.*aliases.zsh" "$HOME/.zshrc"; then
    echo 'source "$HOME/.config/zsh/aliases.zsh"' >>"$HOME/.zshrc"
    echo 'source "$HOME/.config/zsh/exports.zsh"' >>"$HOME/.zshrc"
  fi

  # Setup tmux configuration
  if ! [ -f "$HOME/.tmux.conf" ]; then
    cat >"$HOME/.tmux.conf" <<'EOL'
# Set prefix key to Ctrl+a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Improve colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Set scrollback buffer size
set -g history-limit 10000

# Enable mouse mode
set -g mouse on

# Start window and pane numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when closing
set -g renumber-windows on

# Split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Reload config file
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Enable vi mode
setw -g mode-keys vi

# Setup TPM
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'catppuccin/tmux'

# Initialize TMUX plugin manager
run '~/.tmux/plugins/tpm/tpm'
EOL
  fi

  # Install TPM (Tmux Plugin Manager)
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    print_message "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

# Main function to run everything
main() {
  print_message "Starting setup..."

  detect_os
  # install_package_managers
  # install_zsh
  # install_languages
  # install_neovim
  # install_dev_tools
  # configure_git
  setup_dotfiles

  print_success "Setup completed successfully!"
  print_message "Please restart your terminal or run 'source ~/.zshrc' to apply all changes."
}

# Run the main function
main
