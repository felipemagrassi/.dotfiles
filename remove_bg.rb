require 'json'

new_wallpaper = Dir.glob("#{Dir.home}/.dotfiles/wallpapers/blank.gif")

file = File.read(ARGV[0])
data_hash = JSON.parse(file)

image = data_hash['profiles']['list']
        .find { |profile| profile['name'] == 'Ubuntu' }['backgroundImage']
        .split('\\')

image[-1] = new_wallpaper.sample.split('/')[-1]

data_hash['profiles']['list']
  .find { |profile| profile['name'] == 'Ubuntu' }['backgroundImage'] = image.join('\\')

File.write(ARGV[0], JSON.dump(data_hash))
