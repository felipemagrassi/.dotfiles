REGOLITH_SETTINGS_PATH = "#{Dir.home}/.dotfiles/regolith/.config/regolith3/Xresources"

WALLPAPER_LINE = "regolith.wallpaper.file"
WALLPAPER_OPTION = "regolith.wallpaper.options"
LOCKSCREEN_WALLPAPER_LINE = "regolith.lockscreen.wallpaper.file"
LOCKSREEN_WALLPAPER_OPTION = "regolith.lockscreen.wallpaper.options"
GNOME_WALLPAPER_LINE = "gnome.wallpaper"

USED_OPTION = "none"

def add_settings
  puts("adding settings")
  regolith_settings = File.read(REGOLITH_SETTINGS_PATH)

  new_settings = regolith_settings
    .split("\n")
    .push("#{WALLPAPER_OPTION}: #{USED_OPTION}")
    .push("#{LOCKSREEN_WALLPAPER_OPTION}: #{USED_OPTION}")
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
  remove_settings
  add_settings

  refresh
end

main
