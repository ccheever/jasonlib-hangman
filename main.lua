require "lib"

local font

local keyboardLetters = {
  {
    "q",
    "w",
    "e",
    "r",
    "t",
    "y",
    "u",
    "i",
    "o",
    "p"
  },
  {"a", "s", "d", "f", "g", "h", "j", "k", "l"},
  {"z", "x", "c", "v", "b", "n", "m"}
}

local zones

function _LOAD()
  THEME("sketch")
  font = love.graphics.newFont("./8bitwonder.ttf", 15)
end

function Keyboard(x, y, props, context)
  local s = ""
  for i, row in ipairs(keyboardLetters) do
    for j, c in ipairs(row) do
      local x_ = x + ((i / 2) + j) * 40
      local y_ = y + i * 40
      KeyboardKey(x_, y_, {c = c})
      -- RECTFILL(x_ - 3, y_ - 3, x_ + 15, y_ + 15, "black")
      -- TEXT(string.upper(c), x_, y_, 1.0, "white", font)
    end
  end
end

function addZone(x, y, x2, y2, onClick, data)
  table.insert(zones, {x = x, y = y, x2 = x2, y2 = y2, onClick = onClick, data = data})
end

function letterPressed(data, click)
  print("Pressed " .. data.c .. " " .. click.x .. ", " .. click.y)
end

function KeyboardKey(x, y, props, context)
  local s = string.upper(props.c)
  RECTFILL(x - 8, y - 6, x + 30, y + 30, "black")
  TEXT(s, x, y, 2.0, "white", props.font or font)
  addZone(x - 8, y - 6, x + 30, y + 30, letterPressed, props)
end

function _DRAW()
  zones = {}
  local w = W()
  local h = H()
  RECTFILL(0, 0, w, h, {0.5, 0.5, 0.5})
  Keyboard(0, 280)
end

function love.mousepressed(x, y, button, istouch, presses)
  for i, z in ipairs(zones) do
    if (z.x < x and z.y < y and z.x2 > x and z.y2 > y) then
      print("hit in zone (" .. z.x .. ", " .. z.y .. " - " .. z.x2 .. ", " .. z.y2 .. ") for " .. z.data.c)
      z.onClick(z.data, {x = x, y = y, button = button, istouch = istouch, presses = presses})
    end
  end
end

function _UPDATE()
end
