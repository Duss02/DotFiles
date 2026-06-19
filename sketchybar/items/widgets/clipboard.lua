local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Function to get clipboard content
local function get_clipboard_content()
  local handle = io.popen("pbpaste")
  local result = handle:read("*a")
  handle:close()
  return result
end

-- Function to get first 5 characters
local function get_first_5_chars(text)
  if not text or text == "" then
    return "empty"
  end
  local cleaned = text:gsub("\n", " "):gsub("\r", " ")
  if string.len(cleaned) <= 5 then
    return cleaned
  else
    return string.sub(cleaned, 1, 5) .. "..."
  end
end

local clipboard = sbar.add("item", "widgets.clipboard", {
  position = "right",
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { 
    string = icons.clipboard,
    color = colors.white,
  },
  label = {
    string = get_first_5_chars(get_clipboard_content()),
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
    color = colors.white,
  },
  padding_right = settings.paddings + 6
})

-- Update clipboard content every 2 seconds
sbar.exec("while true; do echo 'clipboard_update'; sleep 2; done | /usr/bin/nc -U $BAR_SOCKET &")

clipboard:subscribe("clipboard_update", function()
  local content = get_clipboard_content()
  clipboard:set({
    label = get_first_5_chars(content)
  })
end)

clipboard:subscribe("mouse.clicked", function(env)
  local content = get_clipboard_content()
  -- Copy to clipboard (redundant but ensures it's copied)
  os.execute("echo '" .. content:gsub("'", "'\"'\"'") .. "' | pbcopy")
  
  -- Show notification with content
  sbar.exec("osascript -e 'display notification \"" .. get_first_5_chars(content) .. "\" with title \"Clipboard Content\"'")
end)

-- Background around the clipboard item
sbar.add("bracket", "widgets.clipboard.bracket", { clipboard.name }, {
  background = { color = colors.bg1 }
})

-- Padding after clipboard item
sbar.add("item", "widgets.clipboard.padding", {
  position = "right",
  width = settings.group_paddings
}) 