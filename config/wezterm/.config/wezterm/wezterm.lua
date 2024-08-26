-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = 'arcoiris'
config.font = wezterm.font("JetBrainsMono NF")
config.font_size = 19

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config