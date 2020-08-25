local API = require("buttonAPI")
local event = require("event")
local term = require("term")
local component = require("component")
local colors = require("colors")
local sides = require("sides")
local gpu = component.gpu

local spawners = require("settings")

-- Variables
local managedSides = {
  sides.bottom,
  sides.top,
  sides.north,
  sides.south,
  sides.west,
  sides.east
}
local redstoneControllers = {}
for address, type in pairs(component.list()) do
  if type == "redstone" then
    table.insert(redstoneControllers, component.proxy(address))
  end
end

-- Base Functions
function resetSpawners()
  for i, spawner in pairs(spawners) do
    redstoneControllers[spawner.controller].setOutput(spawner.side, spawner.state)
    if spawner.state == 255 then
      API.toggleButton(spawner.name)
    end
  end
end

-- GUI
local w, h = mon.getResolution()
local buttonWidth = 20
local buttonHeight = 2
local buttonSpace = 3
local numColumns = 6

function API.fillTable()
  for i, spawner in pairs(spawners) do
    local onClick = function()
      API.toggleButton(spawner.name)
      if buttonStatus == true then
        spawner.state = 255
      else
        spawner.state = 0
      end
      redstoneControllers[spawner.controller].setOutput(spawner.side, spawner.state)
    end

    local xMin = 10 + ((buttonWidth + buttonSpace) * ((i - 1) % numColumns))
    local xMax = xMin + buttonWidth
    local yMin = 3 + ((buttonHeight + buttonSpace) * math.floor((i - 1) / numColumns))
    local yMax = yMin + buttonHeight
    API.setTable(spawner.name, onClick, xMin, xMax, yMin, yMax)
  end
  API.screen()
end

function getClick()
  local _, _, x, y = event.pull(1,touch)
  if x == nil or y == nil then
    local h, w = gpu.getResolution()
    gpu.set(h, w, ".")
    gpu.set(h, w, " ")
  else
    API.checkxy(x,y)
  end
end

-- Launching
term.setCursorBlink(false)
API.clear()
API.fillTable()
resetSpawners()

API.heading("Mob Duplicator Controller")
API.label(1, h - 1, "Created by Darkanakin41")

while true do
  getClick()
end