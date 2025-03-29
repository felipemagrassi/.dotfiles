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
    extract
    archive
)

# Aliases
source ~/.alises 
source ~/.alises_private
# Env
source ~/.exports
# Functions
source ~/.functions
source ~/.functions_private
# Private config
source ~/.privaterc
source $ZSH/oh-my-zsh.sh
