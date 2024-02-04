git clone https://github.com/alacritty/alacritty tmp-alacritty
cd tmp-alacritty
cargo build --release

infocmp alacritty
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

cd ..
rm -rf tmp-alacritty

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 50
sudo update-alternatives --config x-terminal-emulator

cd ~/.dotfiles
stow alacritty
