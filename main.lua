require "lib"

local http = require "copas.http"
local cjson = require "cjson"

local font
local word = "#loading"
local link
local guessedLetters
local strikes
local win
local lose

local hangmanColor = "white"

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
  word = "#loading"
  guessedLetters = {}
  strikes = 0
  win = false
  lose = false
  loadWord()
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
      -- print(val.query .. "  /  " .. val.link)
      -- word = "nuggets vs trailblazers"
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
  if str == "#loading" then
    return
  end
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
  guessLetter(data.c)
end

function KeyboardKey(x, y, props, context)
  local s = string.upper(props.c)
  RECTFILL(x - 8, y - 6, x + 30, y + 30, "black")
  if isLetterGuessed(props.c) then
    color = "gray"
  else
    color = "white"
  end
  TEXT(s, x, y, 2.0, color, props.font or font)
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
  LINE(x + 150, y - 15, x + 150, y + 10)
  LINE(x + 150, y - 15, x + 300, y - 15)
  LINE(x + 300, y - 15, x + 300, y + 350)
  LINE(x, y + 350, x + 300, y + 350)
end

function HangmanDrawing(x, y, props, context)
  Gallows(x, y, props, context)
  -- local strikes = props.strikes
  -- All these are drawn relative to the HangmanDrawing
  -- print("strikes = " .. strikes)
  if strikes > 0 then
    Head(x, y, props, context)
  end
  if strikes > 1 then
    Torso(x, y, props, context)
  end
  if strikes > 2 then
    LeftArm(x, y, props, context)
  end
  if strikes > 3 then
    RightArm(x, y, props, context)
  end
  if strikes > 4 then
    LeftLeg(x, y, props, context)
  end
  if strikes > 5 then
    RightLeg(x, y, props, context)
  end
end

function Head(x, y, props, context)
  CIRC(x + 150, y + 50, 40, hangmanColor)
end

function Torso(x, y, props, context)
  LINE(x + 150, y + 90, x + 150, y + 200, hangmanColor)
end

function LeftArm(x, y, props, context)
  LINE(x + 150, y + 150, x + 70, y + 100, hangmanColor)
end

function RightArm(x, y, props, context)
  LINE(x + 150, y + 150, x + 230, y + 100, hangmanColor)
end

function LeftLeg(x, y, props, context)
  LINE(x + 150, y + 200, x + 80, y + 300, hangmanColor)
end

function RightLeg(x, y, props, context)
  LINE(x + 150, y + 200, x + 220, y + 300, hangmanColor)
end

function _DRAW()
  zones = {}
  local w = W()
  local h = H()
  RECTFILL(0, 0, w, h, {0.5, 0.5, 0.5})
  Keyboard(0, 280)
  Word(5, 50, {word = word})
  HangmanDrawing(485, 50)
  GuessedLetters(50, 250)
  if win then
    YouWin(50, 100)
  end
  if lose then
    YouLose(50, 100)
  end
  if win or lose then
    LearnMoreButton(300, 100)
    NewGameButton(300, 150)
  end
end

function YouWin(x, y, props, context)
  TEXT("YOU WIN!", x, y, 4.0, "white", props and props.font or font)
end

function YouLose(x, y, props, context)
  TEXT("You Lose :(", x, y, 3.0, "white", props and props.font or font)
  TEXT("The word was", x, y + 70, 1.5, "yellow", props and props.font or font)
  TEXT(string.upper(word), x, y + 90, 2.0, "yellow", props and props.font or font)
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
  if win or lose then
    print("Game already over")
    return
  end
  for i, c2 in ipairs(guessedLetters) do
    if c2 == c then
      print("Already guessed " .. c)
      return
    end
  end

  local found = false
  for i = 1, #word do
    local c2 = word:sub(i, i)
    if c == c2 then
      found = true
      break
    end
  end

  if not found then
    -- print("Adding strike")
    strikes = strikes + 1
    if strikes > 5 then
      lose = true
    end
  end

  table.insert(guessedLetters, c)

  if checkForWin() then
    win = true
  end
end

function checkForWin()
  if word == "#loading" then
    return false
  end
  for i = 1, #word do
    local c = word:sub(i, i)
    local missing = true
    if c == " " then
      missing = false
    else
      for j, c2 in ipairs(guessedLetters) do
        if c == c2 then
          missing = false
        end
      end
    end
    if missing then
      return false
    end
  end
  return true
end

function love.mousepressed(x, y, button, istouch, presses)
  for i, z in ipairs(zones) do
    if (z.x < x and z.y < y and z.x2 > x and z.y2 > y) then
      print("hit in zone (" .. z.x .. ", " .. z.y .. " - " .. z.x2 .. ", " .. z.y2 .. ")")
      z.onClick(z.data, {x = x, y = y, button = button, istouch = istouch, presses = presses})
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  local lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
  local found = false
  for i = 1, #lowercaseLetters do
    local c = lowercaseLetters:sub(i, i)
    -- do something with c
    if c == key then
      found = true
      break
    end
  end
  if not found then
    print("Ignoring key " .. key)
    return
  end
  guessLetter(key)
end

function _UPDATE()
end
