local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 35,
  color = colors.bar.bg,
  blur_radius = 10,
  corner_radius = 12,
  border_width=1,
  border_color=0xB7BBC5ff,
  margin = 3,
  y_offset = -1,
  position = "top",
  sticky = true,
  padding_left = 7,
  padding_right = 7,
  display = "all"
})
