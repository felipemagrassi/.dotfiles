# things to install

for package in ~/.dotfiles/packages.txt; do sudo apt-get install $package; done

curl -sS https://starship.rs/install.sh | sh

curl https://sh.rustup.rs -sSf | sh -s -- -y

cargo install ripgrep

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

chmod +x ./scripts/mise.sh && ./scripts/mise.sh
chmod +x ./scripts/lazydocker.sh && ./scripts/lazydocker.sh
chmod +x ./scripts/lazygit.sh && ./scripts/lazygit.sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

