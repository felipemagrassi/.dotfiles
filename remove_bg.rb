require 'json'

regolith_settings_path = "#{Dir.home}/.dotfiles/regolith/.config/regolith3/Xresources"
wallpapers = Dir.glob("#{Dir.home}/.dotfiles/wallpapers/blank.gif")

regolith_settings = File.read(regolith_settings_path)
wallpaper_line = regolith_settings.split("\n").select { |line| line.include? "regolith.wallpaper.file" }[0]

current_wallpaper = wallpaper_line.split('/')[-1]
new_wallpaper = wallpapers.sample.split('/')[-1]

new_wallpaper_line = wallpaper_line.gsub(current_wallpaper, new_wallpaper)
new_regolith_settings = regolith_settings.gsub(wallpaper_line, new_wallpaper_line)

File.open(regolith_settings_path, 'w') { |file| file.write(new_regolith_settings) }

regolith_cmd = "regolith-look refresh"
system(regolith_cmd)
