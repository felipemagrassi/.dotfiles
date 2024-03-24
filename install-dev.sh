wget -O dbeaver.deb "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
sudo dpkg -i dbeaver.deb

wget -O insomnia.deb "https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website" 

sudo dpkg -i insomnia.deb
rm insomnia.deb dbeaver.deb
