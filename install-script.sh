# things to install
sudo apt-get install -y \
  stow \
  zsh \
  vim \
  tmux \
  xclip \
  git \
  curl \
  dirmngr gpg gawk \
  git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev \
  keychain \
  mpv  \
  fzf \
  lzma

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

mkdir ~/.local/share/fonts -p
cp fonts/Meslo* ~/.local/share/fonts

fc-cache -f -v

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

rm ~/.zshrc

stow zsh
stow starship
stow mpv

# Installing asdf
cd 
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
source ~/.zshrc
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin add python https://github.com/asdf-community/asdf-python
asdf install nodejs latest
asdf install ruby latest
asdf install python latest
asdf global nodejs latest
asdf global ruby latest
asdf global python latest
cd

