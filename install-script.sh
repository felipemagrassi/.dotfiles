# things to install
sudo apt-get install -y \
  stow \
  zsh \
  git \
  curl \
  dirmngr gpg gawk \
  git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev \
  keychain \
  mpv  \
  fzf

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -sS https://starship.rs/install.sh | sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

stow zsh
stow starship
stow mpv

# Installing asdf
cd 
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
source ~/.zshrc
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install nodejs latest
asdf install ruby latest
asdf global nodejs latest
asdf global ruby latest
cd

