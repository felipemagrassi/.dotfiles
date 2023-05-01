#!/bin/sh
# HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000
SAVEHIST=1000000
export EDITOR="nvim"
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

/usr/bin/keychain $HOME/.ssh/id_ed25519
source $HOME/.keychain/"$(hostname)"-sh

# asdf
asdf_dir="${asdf_dir:-$HOME/.asdf}"

if [[ -d $asdf_dir ]]; then
  source $asdf_dir/asdf.sh
fi
