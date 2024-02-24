echo "Installing Fonts"
cp ~/.dotfiles/fonts/* ~/.local/share/fonts
fc-cache -fv
echo "Done installing fonts"
