
gd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

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

# Git aliases
alias shipit="git push --set-upstream origin HEAD"
alias gs='git status'
alias ga='git add --all'
alias gc='git commit -m'
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
