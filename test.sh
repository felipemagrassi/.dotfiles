while read p; do 
	sudo apt-get install $p -y 
done < ~/.dotfiles/packages.txt
