#!/bin/sh

function run_test() {
    project=$(pwd)
    developer_cli=$HOME/blu/developer-cli
    current_project=$(pwd | awk -F "/" '{print $NF}')

    cd $developer_cli &&
      APP=$current_project make test file=$1

    cd $project
}

precmd() { eval "$PROMPT_COMMAND" }

export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}: ${PWD##*/}\007"'

# history
SAVEHIST=10000
HISTFILE=~/.zsh_history

# source
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"

eval "$(starship init zsh)"
