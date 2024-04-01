wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_0-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list

sudo apt update
sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille regolith-look-dracula regolith-look-blackhole
sudo apt purge regolith-rofication
sudo apt install regolith-desktop regolith-session-sway regolith-look-nord regolith-look-ayu dunst
sudo apt install pulseaudio-module-bluetooth -y
sudo apt install -y i3xrocks-focused-window-name \
  i3xrocks-battery i3xrocks-bluetooth i3xrocks-media-player \
  i3xrocks-temp i3xrocks-volume i3xrocks-weather
