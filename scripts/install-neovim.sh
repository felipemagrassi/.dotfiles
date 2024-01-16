# Install Neovim
echo "Installing Neovim"
cd
sudo apt-get install ninja-build gettext cmake unzip curl -y
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd 
echo "Done installing neovim"

cd ~/.dotfiles
stow nvim
