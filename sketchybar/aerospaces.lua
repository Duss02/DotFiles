local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

function parse_string_to_table(s)
  local result = {}
  for line in s:gmatch("([^\n]+)") do
    table.insert(result, line)
  end
  return result
end

local file = io.popen("aerospace list-workspaces --all")
local result = file:read("*a")
file:close()

local workspaces = parse_string_to_table(result)
for i, workspace in ipairs(workspaces) do
  local space = sbar.add("item", "space." .. workspace, {
    icon = {
      font = { family = settings.font.numbers },
      string = workspace,
      padding_left = 8,
      padding_right = 3,
      color = colors.grey,
      highlight_color = colors.white,
    },
    label = {
      padding_right = 11,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 0,
      height = 26,
      border_color = colors.grey,
    },
    popup = { background = { border_width = 0, border_color = colors.grey } }
  })

  spaces[workspace] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.transparent,
      height = 28,
      border_width = 2,
    }
  })

  -- Padding space
  sbar.add("space", "space.padding." .. workspace, {
    space = tonumber(workspace),
    script = "",
    width = settings.group_paddings,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left= 2,
    padding_right= 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("aerospace_workspace_change", function(env)
    local selected = tostring(env.FOCUSED_WORKSPACE) == tostring(workspace)
    -- Debug: stampa il workspace corrente
    print("Workspace " .. workspace .. " - Selected: " .. tostring(selected) .. " - Focused: " .. tostring(env.FOCUSED_WORKSPACE))
    
    space:set({
      icon = { highlight = selected },
      label = { highlight = selected },
      background = { 
        border_color = selected and colors.grey or colors.transparent, 
        color = selected and colors.bg2 or colors.bg1 
      }
    })
    space_bracket:set({
      background = { 
        border_color = selected and colors.white or colors.transparent, 
        color = selected and colors.transparent or colors.transparent 
      }
    })
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      if env.BUTTON == "right" then
        -- Per aerospace, chiudiamo tutte le finestre nel workspace per "distruggerlo"
        sbar.exec("aerospace workspace " .. workspace .. " && aerospace close-all-windows-but-current --quit-if-last-window")
      else
        -- Focus del workspace
        sbar.exec("aerospace workspace " .. workspace)
      end
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

-- Funzione per aggiornare le icone delle app nei workspace
local function updateWindows()
  sbar.exec("aerospace list-windows --all --format '%{workspace} %{app-name}'", function(windows_output)
    local workspace_apps = {}
    
    -- Inizializza tutti i workspace
    for _, workspace in ipairs(workspaces) do
      workspace_apps[workspace] = {}
    end
    
    -- Parse dell'output
    for line in windows_output:gmatch("[^\n]+") do
      local workspace, app = line:match("^(%S+)%s+(.+)$")
      if workspace and app and workspace_apps[workspace] then
        workspace_apps[workspace][app] = (workspace_apps[workspace][app] or 0) + 1
      end
    end
    
    -- Aggiorna le label per ogni workspace
    for workspace, apps in pairs(workspace_apps) do
      if spaces[workspace] then
        local icon_line = ""
        local no_app = true
        
        for app, count in pairs(apps) do
          no_app = false
          local lookup = app_icons[app]
          local icon = ((lookup == nil) and app_icons["Default"] or lookup)
          icon_line = icon_line .. icon
        end
        
        if no_app then
          icon_line = " "
        end
        
        sbar.animate("tanh", 10, function()
          spaces[workspace]:set({ label = { string = icon_line } })
        end)
      end
    end
  end)
end

-- Aggiornamento iniziale delle finestre
updateWindows()

-- Sottoscrizione agli eventi di cambio workspace per aggiornare le icone
for _, workspace in ipairs(workspaces) do
  if spaces[workspace] then
    spaces[workspace]:subscribe("aerospace_workspace_change", updateWindows)
  end
end

-- Imposta lo stato iniziale degli spazi
sbar.exec("aerospace list-workspaces --focused", function(focused_output)
  local focused_workspace = focused_output:gsub("%s+", "")
  sbar.trigger("aerospace_workspace_change", { FOCUSED_WORKSPACE = focused_workspace })
end)