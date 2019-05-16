require "lib"

local http = require "copas.http"
local cjson = require "cjson"

local font
local word
local link
local guessedLetters
local strikes 

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
  init()
end

function init()
  loadWord()
  guessedLetters = {}
  strikes = 0
end

function loadWord()
  network.async(
    function()
      local sink = {}
      local response, httpCode, headers, status =
        http.request {
        method = "GET",
        url = "https://hangman-endpoint.onrender.com/",
        -- headers = {
        --   ["Content-Type"] = "application/json",
        --   ["Accept"] = "application/json",
        --   ["Content-Length"] = #source,
        --   ["Connection"] = "keep-alive"
        -- }
        sink = ltn12.sink.table(sink)
      }
      local val = cjson.decode(table.concat(sink))
      print(val.query .. "  /  " .. val.link)
      word = val.query
      link = val.link
    end
  )
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

function Word(x, y, props, context)
  local str = props.word
  if not str then
    return
  end
  for i = 1, #str do
    local c = str:sub(i, i)
    local x_ = x + 25 * i
    local y_ = y
    if c == " " then
      WordSpace(x_, y_, {c = c}, context)
    elseif isLetterGuessed(c) then
      WordLetter(x_, y_, {c = c}, context)
    else
      WordBlank(x_, y_, {c = c}, context)
    end
  end
end

function WordSpace(x, y, props, context)
end

function WordBlank(x, y, props, context)
  TEXT("_", x, y, 2.0, "cyan", props.font or font)
end

function WordLetter(x, y, props, context)
  TEXT(string.upper(props.c), x, y, 2.0, "cyan", props.font or font)
  -- TEXT(string.upper(props.c), x, y, 2.0, "red", props.font or font)
end

function GuessedLetters(x, y)
  for i, c in ipairs(guessedLetters) do
    TEXT(string.upper(c), x + i * 30 - 30, y, 2.0, "red")
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

function NewGameButton(x, y, props, context)
  RECTFILL(x, y, x + 150, y + 30, "green")
  TEXT("New Game", x + 11, y + 2, 2.0, "yellow", props and props.font or font)
  addZone(x, y, x + 150, y + 30, init, {})
end

function goToLink()
  love.system.openURL(link)
end

function LearnMoreButton(x, y, props, context)
  RECTFILL(x, y, x + 150, y + 30, "green")
  TEXT("Learn More", x + 11, y + 2, 2.0, "yellow", props and props.font or font)
  addZone(x, y, x + 150, y + 30, goToLink, {})
end

function Gallows(x, y) 
end


function _DRAW()
  zones = {}
  local w = W()
  local h = H()
  RECTFILL(0, 0, w, h, {0.5, 0.5, 0.5})
  Keyboard(0, 280)
  Word(50, 50, {word = word})
  GuessedLetters(50, 210)
  NewGameButton(550, 380)
  LearnMoreButton(100, 100)
end

function isLetterGuessed(c)
  for i, c2 in ipairs(guessedLetters) do
    if c2 == c then
      return true
    end
  end
  return false
end

function guessLetter(c)
  for i, c2 in ipairs(guessedLetters) do
    if c2 == c then
      print("Already guessed " .. c)
      return
    end
  end
  table.insert(guessedLetters, c)
end



function love.mousepressed(x, y, button, istouch, presses)
  for i, z in ipairs(zones) do
    if (z.x < x and z.y < y and z.x2 > x and z.y2 > y) then
      -- print("hit in zone (" .. z.x .. ", " .. z.y .. " - " .. z.x2 .. ", " .. z.y2 .. ") for " .. z.data.c)
      z.onClick(z.data, {x = x, y = y, button = button, istouch = istouch, presses = presses})
      guessLetter(z.data.c)
    end
  end
end

function _UPDATE()
end
