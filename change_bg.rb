require 'json'

wallpapers = Dir.glob("#{Dir.home}/.dotfiles/wallpapers/*")
new_wallpaper = wallpapers.sample.split('/')[-1]

file = File.read(ARGV[0])
data_hash = JSON.parse(file)

image = data_hash['profiles']['list']
        .find { |profile| profile['name'] == 'Ubuntu' }['backgroundImage']
        .split('\\')

new_wallpaper = wallpapers.sample.split('/')[-1] while new_wallpaper == image[-1] || new_wallpaper == 'blank.gif'
image[-1] = new_wallpaper

data_hash['profiles']['list']
  .find { |profile| profile['name'] == 'Ubuntu' }['backgroundImage'] = image.join('\\')

File.write(ARGV[0], JSON.dump(data_hash))
