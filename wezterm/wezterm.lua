local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",
    color_scheme = "Nord (Gogh)",
    default_cursor_style = "BlinkingBar",
    enable_tab_bar = false,
    font_size = 13.5,
    background = {
        {
          source = {
            File = "/Users/" .. os.getenv("USER") .. "/.config/wezterm/wallpaper.png",
          },
          hsb = {
            hue = 1.0,
            saturation = 1.02,
            brightness = 0.25,
          },
          -- attachment = { Parallax = 0.3 },
          -- width = "100%",
          -- height = "100%",
        },
        {
          source = {
            Color = "#282c35",
          },
          width = "100%",
          height = "100%",
          opacity = 0.55,
        },
      },
}

return config
