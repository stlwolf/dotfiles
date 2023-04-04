local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'iceberg-dark'
config.window_background_opacity = 0.9

config.font = wezterm.font("Rounded-X Mgen+ 1mn", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 18.0

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.initial_cols = 180
config.initial_rows = 50
-- config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false

config.scrollback_lines = 8192
config.enable_scroll_bar = true

config.keys = {
  { key = 'f', mods = 'CTRL|CMD', action = wezterm.action.ToggleFullScreen },
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
}

config.window_background_image = ''

config.window_background_image_hsb = {
  -- Darken the background image by reducing it to 1/3rd
  brightness = 0.2,

  -- You can adjust the hue by scaling its value.
  -- a multiplier of 1.0 leaves the value unchanged.
  hue = 1.0,

  -- You can adjust the saturation also.
  saturation = 1.0,
}
return config