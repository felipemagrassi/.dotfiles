alias rebase='git fetch origin master:master; git rebase master'
alias lvim='$HOME/.local/bin/lvim'
alias j='z'
alias f='zi'
alias g='lazygit'
alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"
alias monitor-off=sudo sh -c 'xset -display :0.0 dpms force off; read ans; xset -display :0.0 dpms force on'
# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls --color=auto'

alias remove-bg='ruby $HOME/.dotfiles/remove_bg.rb'
alias change-bg='ruby $HOME/.dotfiles/change_bg.rb'

# Git aliases
alias shipit="git push --set-upstream origin HEAD"
alias gs='git status'
alias ga='git add --all'
alias gc='git commit -m'
alias gct='git commit -m "$(date +"%D %T")"'
alias gca='git commit --amend --no-edit'
alias gcb='git checkout -b'
alias grs='git reset --soft HEAD~1'
alias gp='git push --force'
alias gr='git rebase -i'
alias gl="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"

# Rails

alias devlog='tail -f log/development.log'
alias rc='rails c'
alias rcs='rails c --sandbox'
alias rgm='rails g migration'
alias rdm='rails db:migrate'
alias rdr='rails db:rollback'

# Tmux

alias ta='tmux attach -t'
alias tl='tmux list-sessions'
