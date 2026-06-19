local colors = require("colors")

-- Equivalent to the --bar domain
-- Bar should be height = 35,
sbar.bar({
  height = 35,
  color = colors.transparent,
  blur_radius = 10,
  corner_radius = 12,
  border_width=1,
  border_color=0x00BBC500,
  margin = 3,
  y_offset = -1,
  position = "top",
  sticky = true,
  padding_left = 7,
  padding_right = 7,
  display = "all"
})
