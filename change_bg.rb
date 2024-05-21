# puts Dir.glob("#{Dir.home}/.dotfiles/wallpapers/*")
wallpapers = Dir.glob("#{Dir.home}/.dotfiles/wallpapers/*")

system("feh --bg-fill #{wallpapers.sample}")
