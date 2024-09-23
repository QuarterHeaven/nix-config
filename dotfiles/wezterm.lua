local wezterm = require 'wezterm'
local config = {}

config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font 'BlexMono Nerd Font'
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.send_composed_key_when_left_alt_is_pressed = true

return config
