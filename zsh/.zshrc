function pretty_csv {
    column -t -s, -n "$@" | less -F -S -X -K
}

export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/go/bin
export PATH=/home/felipe/.local/bin:$PATH
export EDITOR='vim'

ZSH_THEME="junkfood"
plugins=(git rails asdf keychain zsh-autosuggestions zsh-syntax-highlighting git-auto-fetch)

source $ZSH/oh-my-zsh.sh

alias rebase='git fetch origin master:master; git rebase master'
alias vim='nvim'
alias lvim='nvim'
alias bat='batcat'
alias newbg="ruby $HOME/.dotfiles/change_bg.rb '$HOME/.dotfiles/windows-terminal/setting.json'"
alias removebg="ruby $HOME/.dotfiles/remove_bg.rb '$HOME/.dotfiles/windows-terminal/setting.json'"

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/"$(hostname)"-sh

eval "$(starship init zsh)"

