alias rebase='git fetch origin master:master; git rebase master'
alias vim='nvim'
alias lvim='nvim'
alias newbg="ruby $HOME/.dotfiles/change_bg.rb '$HOME/.dotfiles/windows-terminal/setting.json'"
alias removebg="ruby $HOME/.dotfiles/remove_bg.rb '$HOME/.dotfiles/windows-terminal/setting.json'"
alias j='z'
alias f='zi'
alias g='lazygit'
alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"
# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls --color=auto'

alias gpsup='git push --set-upstream origin $(git_current_branch)'
