local sides = require("sides")

local spawners = {
  {
    name = "Blaze",
    controller = 1,
    side = sides.north,
    state = 0,
  },
  {
    name = "Pink Slime",
    controller = 2,
    side = sides.north,
    state = 255,
  },
}

return spawners