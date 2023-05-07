#!/bin/sh

# history
HISTFILE=~/.zsh_history

# source
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"

eval "$(starship init zsh)"
