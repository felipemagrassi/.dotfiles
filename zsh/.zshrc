export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto      # update automatically without asking
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(
    git 
    zsh-syntax-highlighting 
    zsh-autosuggestions
    zsh-history-substring-search
    z
    docker
)

# Aliases
source ~/.aliases 
touch ~/.aliases_private && source ~/.aliases_private
# Env
source ~/.exports
# Functions
source ~/.functions
touch ~/.functions_private && source ~/.functions_private
# Private config
touch ~/.privaterc && source ~/.privaterc

# dircolors.
if [ -x "$(command -v dircolors)" ]; then
 eval "$(dircolors -b ~/.dircolors)"
fi

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

. "$HOME/.local/bin/env"

