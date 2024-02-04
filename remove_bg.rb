require 'json'

regolith_settings_path = "#{Dir.home}/.dotfiles/regolith/.config/regolith3/Xresources"
wallpapers = Dir.glob("#{Dir.home}/.dotfiles/wallpapers/blank.gif")

regolith_settings = File.read(regolith_settings_path)
wallpaper_option_line = regolith_settings.split("\n").select { |line| line.include? "regolith.wallpaper.options" }[0]

new_regolith_settings = regolith_settings.gsub(wallpaper_option_line, "regolith.wallpaper.options: none")

File.open(regolith_settings_path, 'w') { |file| file.write(new_regolith_settings) }

regolith_cmd = "regolith-look refresh"
system(regolith_cmd)
