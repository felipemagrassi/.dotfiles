# things to install
sudo apt-get install -y \
  stow \
  zsh \
  vim \
  gimp \
  xsel \
  libpq-dev \
  tmux \
  protobuf-compiler \
  xclip \
  git \
  curl \
  dirmngr gpg gawk \
  git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev \
  keychain \
  mpv  \
  cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 \
  lzma



sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl https://sh.rustup.rs -sSf | sh -s -- -y

mkdir ~/.local/share/fonts -p
cp fonts/* ~/.local/share/fonts

fc-cache -f -v

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

rm ~/.zshrc

stow zsh
source ~/.zshrc

# Installing asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

./asdf-plugins.sh nodejs
./asdf-plugins.sh ruby

cargo install ripgrep
chsh -s $(which zsh)

sudo apt install thunar -y
xdg-mime default thunar.desktop inode/directory application/x-gnome-saved-search

./install-kitty.sh
./scripts/install-neovim.sh
./scripts/install-font.sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

