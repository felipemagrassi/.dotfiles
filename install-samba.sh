#!/bin/bash

sudo apt update
sudo apt install samba -y

arr=("4tb" "2tb" "externo" "14tb")

for i in "${arr[@]}"; do 
  echo "creating $i"

  echo "[$i]" | sudo tee -a "/etc/samba/smb.conf" >/dev/null
  echo "   comment = HD $i" | sudo tee -a "/etc/samba/smb.conf" >/dev/null
  echo "   path = /mnt/$i" | sudo tee -a "/etc/samba/smb.conf" >/dev/null
  echo '   read only = no' | sudo tee -a "/etc/samba/smb.conf" >/dev/null
  echo '   browsable = yes' | sudo tee -a "/etc/samba/smb.conf" >/dev/null
  echo '   guest ok = no' | sudo tee -a "/etc/samba/smb.conf" >/dev/null

  echo "finished creating $i"
done

sudo service smbd restart
sudo ufw allow samba

sudo smbpasswd -a felipe
