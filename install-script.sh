# things to install
sudo apt-get install -y \
  stow \
  zsh \
  vim \
  gimp \
  xsel \
  tmux \
  xclip \
  git \
  curl \
  dirmngr gpg gawk \
  git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev \
  keychain \
  mpv  \
  fzf \
  cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 \
  lzma

wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_0-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list

sudo apt update
sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille regolith-look-dracula
sudo apt install regolith-desktop regolith-session-sway regolith-look-nord regolith-look-ayu

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
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

rm -rf ~/.config/regolith 
cd .dotfiles
stow regolith
