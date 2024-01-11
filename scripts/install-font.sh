echo "Installing Fonts"
cd ~/.dotfiles/fonts
cp * ~/.fonts
fc-cache -fv
cd
echo "Done installing fonts"
