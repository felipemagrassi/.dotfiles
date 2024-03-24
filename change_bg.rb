REGOLITH_SETTINGS_PATH = "#{Dir.home}/.dotfiles/regolith/.config/regolith3/Xresources"
WALLPAPERS = Dir.glob("#{Dir.home}/.dotfiles/wallpapers/*")

WALLPAPER_LINE = "regolith.wallpaper.file"
WALLPAPER_OPTION = "regolith.wallpaper.options"
LOCKSCREEN_WALLPAPER_LINE = "regolith.lockscreen.wallpaper.file"
LOCKSREEN_WALLPAPER_OPTION = "regolith.lockscreen.wallpaper.options"
GNOME_WALLPAPER_LINE = "gnome.wallpaper"

USED_OPTION = "zoom"

def current_wallpaper
  regolith_settings = File.read(REGOLITH_SETTINGS_PATH)
  wallpaper_line = regolith_settings.split("\n").select { |line| line.include?("regolith.wallpaper.file") }[0]

  return nil if wallpaper_line.nil?

  @current_wallpaper ||= wallpaper_line.split("/")[-1]
end

def new_wallpaper
  new_wallpaper = WALLPAPERS.sample.split("/")[-1]

  while current_wallpaper == new_wallpaper
    new_wallpaper = WALLPAPERS.sample.split("/")[-1]
  end

  new_wallpaper
end

def add_wallpaper(wallpaper)
  puts("adding wallpaper")
  regolith_settings = File.read(REGOLITH_SETTINGS_PATH)

  wallpaper_path = "#{Dir.home}/.dotfiles/wallpapers/#{wallpaper}"

  new_settings = regolith_settings
    .split("\n")
    .push("#{WALLPAPER_LINE}: #{wallpaper_path}")
    .push("#{WALLPAPER_OPTION}: #{USED_OPTION}")
    .push("#{LOCKSCREEN_WALLPAPER_LINE}: #{wallpaper_path}")
    .push("#{LOCKSREEN_WALLPAPER_OPTION}: #{USED_OPTION}")
    .push("#{GNOME_WALLPAPER_LINE}: #{wallpaper_path}")
    .join("\n")

  File.open(REGOLITH_SETTINGS_PATH, "w") { |file| file.write(new_settings) }
end

def remove_settings
  puts("Removing settings")
  regolith_settings = File.read(REGOLITH_SETTINGS_PATH)

  new_settings = regolith_settings
    .split("\n")
    .reject { |l| l.include?(WALLPAPER_LINE) }
    .reject { |l| l.include?(WALLPAPER_OPTION) }
    .reject { |l| l.include?(LOCKSCREEN_WALLPAPER_LINE) }
    .reject { |l| l.include?(LOCKSREEN_WALLPAPER_OPTION) }
    .reject { |l| l.include?(GNOME_WALLPAPER_LINE) }
    .join("\n")

  File.open(REGOLITH_SETTINGS_PATH, "w") { |file| file.write(new_settings) }
end

def refresh
  puts("Refreshing Regolith")

  regolith_cmd = "regolith-look refresh"
  system(regolith_cmd)
end

def main
  new_wallpaper = new_wallpaper()

  puts("Changing wallpaper from #{current_wallpaper} to #{new_wallpaper}")

  remove_settings
  add_wallpaper(new_wallpaper)

  refresh
end

main
