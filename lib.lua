require 'sounds'
require 'collision'
require 'SpriteSheet'
local moonshine = require 'moonshine'

-- HIGH LEVEL:
-- Make it so that when someone has an idea to work on something,
-- they just start doing it and then get really into it, and then
-- later start doing infrastructural coding. Do not allow any infra-
-- structural coding to need to happen up-front in order to get 
-- started with any new project. Ppl won't start nearly as often.

-- Make game-making feel like a "casual, fun process of discovering what you're making" 
-- rather than a "plan required up-front, then executed upon". People should have free
-- time and think "i'll make something in castle!" and then open upon castle and start
-- a project without even knowing or considering what they're going to make yet.

-- Measure how much this lib is helping by how many steps it
-- reduces from user's workflow, how it 'feels', and qualitative feedback,
-- not just rigid things like number of lines of code saved, and so on.
-- e.g. instead of "look up love.iamge, find love.newImage, create an image,
-- pre-fetch an image, load it, figure out you have to scale an image, 
-- compute the scaling for the image, maybe write a helper method, then 
-- call that method," just allow them to draw the image

-- Should make coders who aren't great at art able to make beautiful
-- things easily that make them feel like talented artists. Kind of how a pentatonic
-- scale can make anyone feel like they know what they're doing as a musician.

-- SOME HUGE CONCERNS:
-- Don't want to fragment community by having too many people doing diff things
-- Want to amplify people sharing code by using similar code
-- Maybe don't want to fragment community by having a bunch of open-source 
-- versions of it out there... open source is bad?

-- SOME DESIGN PRINCIPLES + CONSIDERATIONS:

-- IMPORTANT PRINCIPLES:
-- "Should feel like a glass of ice water in hell" - the refreshing when you finally get to use it after
  -- using other tools.
-- Feel quite f'ing expressive. Really push the sweetspot boundary on the limitations/expressive spectrum
-- Should be an identifiable medium
-- Simplicity should feel accessible/unimposing to beginners, relaxing and fun to advanced programmers
-- Doesn't allow you to get confused if you're not a great programmer (e.g. no async necessary on the surface)
-- Should be congruent with a way for non-coders to control it

-- Consider having tiers of reference manuals, each one self-contained
-- Tiny API
-- Medium API
-- Gigantic API

-- (?-->) If things need to be async calls, then calling them should just automagically do that, if sensible

-- Should feel fast and high fidelity
-- Should allow people to get started so damn fast, iteratively
-- Should require no setup beyond requiring a library
-- Fit into someone's head reasonably quickly
-- Should be Memorable+Intuitive, both method names / params
  -- people's first "guess" should just work
-- Should fit entirely on a cheatsheet, or site, without any scrolling required. Should not
  -- require any navigation or nesting to read it in full with sufficiently large text
-- Should be only one function to do things of a given class (one way to play sounds, one way to draw images)
-- Functions that are at all related in type or parameter format should have identical definitions (e.g. LINE and RECT)
-- Should be maximally expressive
-- Should be frame-locked and smart about what happens if frames are skipped
-- Should clearly enable non-coder tools which control it
-- Naming should be fun/quirky (e.g. timeslide), but not at expense of clarity
-- Shouldn't do "aggregate" operations for people, like algorithms. "Primitive" operations only.
-- Terse. Every char counts.
-- Stick to love2d parameter conventions by default unless there's a really good reason it's bad (e.g. drawImage.. have to scale first)
-- Should allow advanced operations, but with a super smooth learning curve
-- Not explicitly for beginners, but understandable by beginners. Relaxing, intuitive, and easy for advanced coders.
-- Wherever possible, it should be clear what the method does from it's definition. 
  -- no further description needed (though a manual will be provided)
-- Should always be super easy to see manual (e.g. pressing "m" in game pulls this manual over the game)
-- Should not clobber any ability to do love2d stuff
-- Should be an example game, which is a smorgasboard of all this stuff
  -- Should be used in a set of examples that show how awesome it is

-- Have a Secret Menu of special, possibly experimental or less commonly useful, but still rad things.
  -- BPM detection, for example
-- Related methods should start with common prefix (E.g. RECT+RECTFILL, not RECT+FILLRECT)
-- Should have a GUI w minimal tools (sprite ed, data/map ed, color palette, sound chooser/crafter, maybe others)
-- Should be able to save frozen game state at any point
-- Ideally, should be able to have player(s') control data automatically recorded

-- Convention over configuation (e.g. sound files in code are referenced by filename)
-- Should be able to make an entire game in 
-- Should not force opinionated programming paradigms (OO, deisgn  etc.)
-- Should not restrict opinionated programming paradigms
-- Consider method names in ALL_CAPS so that it's known what's from this core library when coding, for consistency, etc)

-- Should bias towards creating shared language and community; people should't 'diverge' much.


-----------------------------
-- PICO-8 INSPIRED
-----------------------------

--
-- CLS()
-- RECT(x1, y1, x2, y2, color)
-- MUSIC(0)
-- SFX(0, 3)
-- RECTFILL(x1, y1, x2, y2, color)
-- PRINT(var1, var2, ..., varN)
-- CIRCFIL(x, y, radius, color)
-- CIRC(x, y, radius, color)
-- LINE(x1, y1, x2, y2, color)
-- PSET(x, y, color)
-- PGET(x, y)

-- CLIPPING:
-- CLIP(x1, y1, x2, y2)
-- RECTFILL(X1, Y1, X2, Y2, COLOR)
-- CLIP()

-- SPRITE()
-- SSPR
-- PAL

-- MSET
-- MAP
-- FSET

-- CURSOR POS AND COLOR:
-- CURSOR(x, y)
-- COLOR(color)

-- MATH
-- COS(x)
-- MID(1, 2, 3)
-- ABS(x)

-- COLLECTIONS
-- A = {}
-- ADD(A, 11)

-- T()

-----------------------------
-- THIS LIB
-----------------------------

-- THEME(type)
-- ID = ADDFILT(type)
-- REMOVEFILT(filterId)
-- a theme is like a filter for an entire game- all parts of it. creates
-- a full aesthetic and allows for quickly switching between each of them
-- aggregate themes which process everything that runs through the game
-- a theme can iterate over all objects in the world and do specific things
-- to each of them
-- it can allow high-level parameter adjustments (e.g. how much pixelation)
-- people should be able to create and publish themes

-- examples:
-- retro theme. pixellates everything (including the music?). 
  -- allows a control for what 'resolution' to retro-ify
  -- if castle has all music and sound data inside of it in the right format,
  -- the sound swapping can be really granular
-- toon theme. adds cartoony look and feel
-- v a p o r theme. adds vaporwave look and feel

---------------
-- MISC
-- PAINTBRUSH? BRUSH? allow custom fills, from a set of presets or custom?

---------------
-- GENERAL
-- W() - get width of game window
-- H() - get width of game window

-- T() - get current total time game has run

-- MAYBE:
-- DT() - callable anywhere in code. gets dt as it currently existed in love.update()

---------------
-- IMAGES

-- IMG(filename, x1, y1, x2, y2, aspect)
-- In ghost's love.load, it pre-processes your code to find any calls to IMG.
-- It looks recursively in every sub-directory for where files with image extensions are
-- it does the castle prefetch api on those filenames, and it calls newImage 
-- it makes sure that the
-- on all of those, assigning them to images which are named something unique like:
-- GHOST_IMG_FILENAME__1
-- It stores those in a lookup table from this filename (with no extension) to the variable
-- It saves the current value of setColor()
-- It calls setColor(1,1,1,1)
-- It calls the following API method:
-- IMG(filename, x1, y1, x2, y2)
-- That method retreives the newImage that was created upon prefetching from that filename, 
-- and then looks it up in the image table.
-- It computes the appropriate scale for the image
-- It resets the color to what it was before?
-- throws an error if image file is not loadable (perhaps because the file type for "example_image" is unacceptable, like example_image.mp3), 
-- so, need a whitelist for which filetypes are acceptable

-- Also could allow gifs:
-- https://notabug.org/pgimeno/gifload
-- GIF(filename, x1, y1, x2, y2 aspect, shouldLoop)

---------------
-- SOCIAL:

-- AVATAR(x1, y1, x2, y2)
-- uses castle's getMe() API to draw the user's avatar scaled to the specified rectangle

-- USERNAME()
-- uses castle's getMe() gets a string of the user's name

---------------
-- STORAGE:

-- USER_STORE(...)
-- GLOBAL_STORE(...)

---------------
-- CHAT:

-- CHAT_WAS_SENT(userID, msg)
-- callback function: called when a message is sent to chat with a particular username

-- CHAT_SEND(message)
-- game can post a message to chat for all users to see
-- CHAT_SEND(message, userId1, userId2, ...)
-- game can post a message to a particular subset of players, like an individual or a team of player

---------------
-- POSTS:
-- 

---------------
-- MUTLIPLAYER:
-- TODO: make a simple multiplayer API, prob using using simulsim

---------------
-- SOUNDS: 

-- TODO: think about allowing to stream youtube music, or from somewhere similar?
-- TODO: simplify this. soundID and filename is too complicated.

-- soundID = PLAYSOUND(filename, volume, {options: looping, pitch, pan, time, onfinishfunc} )
-- if it's called while an existing sound of that name is playing, then it first automatically adds another 
-- channel to that sound's array of channels before it plays it
-- does similar thing to above IMAGES library, where it pre-processes to scan for this method
-- loads all sound files 
-- throws errors when this method is called if that sound isn't of correct filetype
-- internally, calls update each frame in love.update() on my sound engine, so that when the sound is done,
-- it can call onFinishFunc
-- returns an unique integer id for that particular instance of the sound. that soundID goes nil 
-- in the internal data structure when the sound is done playing, but it fails silently and prints a warning
-- if someone attempts to act on that ID at a later time. 
-- soundIDs internally are not re-used-it just increments to the next integer in a counter

-- STOPSOUND(filename)
-- stops all instances of sounds with that filename

-- STOPSOUND(soundID)
-- stops that particular instance

-- PAUSESOUND(filename)
-- PAUSESOUND(soundID)
--

-- FADESOUND(filename OR soundID, fromVol, toVol, startTime, duration, onfinishfunc)
-- fades sound volume over dur from one vol to another. uses existing sound already playing,
-- or if no such sound is playing, starts a new one from the given filename

---------------
-- POSTS:

-- POST_PROMPT(titlePrompt, avatar)

local Imgs = {}
local currMusic = 'none'

local soundFilenames = {}
local imgFilenames = {}

-- TODO: use castle's API to pre-fetch these assets ... before load time?
-- TODO: allow user to specify file extensions, or not, and dynamically
-- figure out here what filetype they are in order to load that type
-- there's enough info in the method names "PLAYSND" and "IMG" to be able to 
-- disambiguate files with the same name that are of different media types
-- but if someone has a sound titled .mp3 and another .wav, there will need
-- to be an error thrown informing them to disambiguate
-- also, name the sounds with the full file path, or just the leaf name?
-- consider that trade-off
function preprocess(file)
  for line in love.filesystem.lines('main.lua') do
    -- TODO: make it so changing PLAYSND's method name changes gmatch string as well
    for soundFilename in string.gmatch(line, "PLAYSND%('([^']+)") do
      if soundFilenames[soundFilename] == nil then
        table.insert(soundFilenames, soundFilename)
      end
    end
    -- TODO: make it so changing IMG's method name changes gmatch string as well
    for imgFilename in string.gmatch(line, "IMG%('([^']+)") do
      if imgFilenames[imgFilename] == nil then
        table.insert(imgFilenames, imgFilename)
      end
    end
    -- TODO: make it so changing SPRITE's method name changes gmatch string as well
    for imgFilename in string.gmatch(line, "SPRITE%('([^']+)") do
      if imgFilenames[imgFilename] == nil then
        table.insert(imgFilenames, imgFilename)
      end
    end
  end
end

local user = {}

local startTime = nil

function loadAssets()
  table.insert(soundFilenames, 'retro_1.mp3')
  table.insert(soundFilenames, 'retro_2.mp3')
  table.insert(soundFilenames, 'lofi_1.mp3')
  table.insert(soundFilenames, 'lofi_2.mp3')
  table.insert(soundFilenames, 'gameboy.mp3')
  table.insert(soundFilenames, 'virtualboy.mp3')
  table.insert(soundFilenames, 'jamesshinra.mp3')
  table.insert(soundFilenames, 'old_timey.mp3')

  -- sounds
  for k, v in pairs(soundFilenames) do
    Sounds[v] = Sound:new(v, 3) -- TODO: dynamically size the sound channel amount
  end

  -- images
  for k, v in pairs(imgFilenames) do
    Imgs[v] = love.graphics.newImage(v)
  end
end

-- TODO: get and load all sounds (use pre-fetch API), load em into mem
-- TODO: get all images, pre-fetch 'em by default, load em into mem
function love.load()
  -- TODO: should instead get main entry point from .castle and preprocess 
  -- starting there. also need to pre-process recursively
  preprocess('main.lua')
  loadAssets()

  startTime = love.timer.getTime()

  Imgs['manual'] = love.graphics.newImage('manual.png')

  network.async(function()
    user.name = castle.user.getMe().username
    user.avatarImage = love.graphics.newImage(castle.user.getMe().photoUrl)
    Imgs['avatar'] = user.avatarImage
  end)

  love.graphics.setDefaultFilter('linear', 'linear', 1)
  _LOAD()
end

local keysJustPressed = {}
local keysHeld = {}

-- TODO:
function love.update(dt)
  -- TODO: update sound engine and anything else per update call
  _UPDATE(dt)

  -- nil any keypresses
  for k, v in pairs(keysJustPressed) do
    keysJustPressed[k] = false
  end
end

local showingManual = false

function love.keypressed(key, scancode, isrepeat)
  if key == 'm' then
    showingManual = not showingManual
  else
    keysJustPressed[key] = true
    keysHeld[key] = true
  end
end

function love.keyreleased(key, scancode)
  if keysHeld[key] ~= nil then
    keysHeld[key] = false
  else
    -- TODO: ERROR: this case shouldn't happen
  end
end

function BTN(key)
  if key == 'm' then
    -- TODO: throw warning about 'm' being a reserved key
  elseif keysHeld[key] ~= nil then
    --print(key)
    return keysHeld[key]
  end
end

function BTNP(key)
  if key == 'm' then
    --TODO: throw warning about 'm' being a reserved key
  elseif keysJustPressed[key] ~= nil then
    val = keysJustPressed[key]
    keysJustPressed[key] = false
    return val
  end
end

local filter_effect = nil

function love.draw()
  if filter_effect then
    filter_effect(function()
      _DRAW()
    end)
  else
    _DRAW()
  end
  if showingManual then
    IMG('manual', 20, 20, W() - 20, H() - 20, 'aspect_fill')
  end
end

function W()
  return love.graphics.getWidth()
end

function H()
  return love.graphics.getHeight()
end

function T()
  return love.timer.getTime() - startTime
end

-- TODO: make this do the thing. make something similarly architected to moonshine,
-- but with more meaningful filters and proper performance across machines

-- TODO: make a simple grayscale filter as a starting example
-- TODO: allow filters per object
-- TODO: assign a filterId to each filter
function ADD_FILTER(type)
  filter_effect = moonshine(moonshine.effects.dmg)
  filter_effect.dmg.palette = 'greyscale'
end

function REMOVE_FILTER(filterId)
  filter_effect = nil -- TODO: remove by filterId
end

-- TODO: add more?
local retroThemeColors = {
  black = {0, 0, 0},
  white = {1, 1, 1},
  gray = {.5, .5, .5},
  red = {1, 0, 0},
  green = {0, 1, 0},
  blue = {0, 0, 1},
  yellow = {1.0, 1.0, 0.0},
  orange = {0.9, 0.3, 0},
  purple = {1.0, 0.0, 1.0},
  cyan = {0.0, 1.0, 1.0},
}

local gameboyThemeColors = {
  black = {156/255, 186/255, 41/255},
  white = {140/255, 170/255, 38/255},
  gray = {140/255, 170/255, 38/255},
  red = {49/255, 97/255, 50/255},
  green = {49/255, 97/255, 50/255},
  blue = {49/255, 97/255, 50/255},
  yellow = {17/255, 55/255, 17/255},
  orange = {49/255, 97/255, 50/255},
  purple = {17/255, 55/255, 17/255},
  cyan = {17/255, 55/255, 17/255},
}

local virtualBoyColors = {
  black = {0, 0, 0},
  white = {1, .08, .08},
  gray = {1, .08, .08},
  red = {1, .08, .08},
  green = {1, .08, .08},
  blue = {1, .08, .08},
  yellow = {1, .08, .08},
  orange = {1, .08, .08},
  purple = {1, .08, .08},
  cyan = {1, .08, .08},
}

local sketchThemeColors = {
  black = {0, 0, 0},
  white = {1, 1, 1},
  gray = {.5, .5, .5},
  red = {0.75, 0.75, 0.75},
  green = {0.7, 0.7, 0.7},
  blue = {0.6, 0.6, 0.6},
  yellow = {0.95, 0.95, 0.95},
  orange = {0.8, 0.8, 0.8},
  purple = {0.85, 0.85, 0.85},
  cyan = {0.95, 0.95, 0.95},
}

local lofiThemeColors = {
  black = {0, 0, 0},
  white = {1, 1, 1},
  gray = {.65, .65, .65},
  red = {249/255, 140/255, 182/255},
  green = {145/255, 210/255, 144/255},
  blue = {154/255, 206/255, 223/255},
  yellow = {255/255, 250/255, 129/255},
  orange = {252/255, 169/255, 133/255},
  purple = {165/255, 137/255, 193/255},
  cyan = {204/255, 236/255, 239/255},
}

local currThemeColors = retroThemeColors

function THEME(newTheme)
  if newTheme == them then
    return
  end

  STOPSND(currMusic)

  theme = newTheme
  if theme == 'none' or theme == nil then
    filter_effect = nil
  elseif theme == 'retro' then
    currThemeColors = retroThemeColors
    currMusic = 'retro_1.mp3'
    network.async(function()
      filter_effect = moonshine(moonshine.effects.glow)
      --.chain(moonshine.effects.pixelate)
      .chain(moonshine.effects.crt)
      .chain(moonshine.effects.scanlines)
      filter_effect.glow.strength = 10.0
      filter_effect.glow.min_luma = 0.2
      --filter_effect.pixelate.size = {8, 4}
      --filter_effect.pixelate.feedback = 0.65
      filter_effect.crt.distortionFactor = {1.05, 1.06}
      filter_effect.scanlines.opacity = 1.0
      filter_effect.scanlines.thickness = 0.4
    end)
  elseif theme == 'sketch' then
    currThemeColors = sketchThemeColors
    currMusic = 'old_timey.mp3'
    network.async(function()
      filter_effect = moonshine(moonshine.effects.sketch)
      .chain(moonshine.effects.fastgaussianblur)
      .chain(moonshine.effects.filmgrain)
      filter_effect.sketch.amp = 0.0007
      filter_effect.filmgrain.size = 4
      filter_effect.filmgrain.opacity = 0.7
      filter_effect.fastgaussianblur.taps = 5
    end)
  elseif theme == 'gameboy' then
    currThemeColors = gameboyThemeColors
    currMusic = 'gameboy.mp3'
    network.async(function()
      filter_effect = moonshine(moonshine.effects.pixelate)
      --.chain(moonshine.effects.dmg)
      --filter_effect.dmg.palette = 'green'
      filter_effect.pixelate.size = {5, 5}
      filter_effect.pixelate.feedback = 0.0
    end)
  elseif theme == 'virtualboy' then
    currThemeColors = virtualBoyColors
    currMusic = 'virtualboy.mp3'
    network.async(function()
      filter_effect = moonshine(moonshine.effects.glow)
      .chain(moonshine.effects.pixelate)
      .chain(moonshine.effects.scanlines)
      filter_effect.pixelate.size = {2, 2}
      filter_effect.glow.strength = 6.0
      filter_effect.glow.min_luma = 0.3
      -- filter_effect.dmg.palette = {
      --   {10/255, 0/255, 0/255},
      --   {142/255, 40/255, 60/255},
      --   {200/255, 100/255, 120/255},
      --   {255/255, 200/255, 210/255},
      -- }
    end)
  elseif theme == 'cyber' then
    currThemeColors = lofiThemeColors
    currMusic = 'jamesshinra.mp3'
    network.async(function()
      filter_effect = moonshine(moonshine.effects.fastgaussianblur)
      filter_effect.fastgaussianblur.taps = 3
    end)
  elseif theme == 'lofi' then
    currThemeColors = retroThemeColors
    currMusic = 'lofi_1.mp3'
    network.async(function()
      filter_effect = moonshine(moonshine.effects.glow)
      .chain(moonshine.effects.fastgaussianblur)
      .chain(moonshine.effects.godsray)
      filter_effect.fastgaussianblur.taps = 3
      filter_effect.glow.strength = 1.0
      filter_effect.glow.min_luma = 0.4
    end)
  end

  PLAYSND(currMusic, 1.0, true)
end

-- TODO: make 'type' param optional
function COLLIDED(a, b, type)
  if type == nil then
    type = 'basic'
  end

  if type == 'basic' then
    if a.type == 'rect' and b.type == 'rect' then
      -- TODO: do AABB collision
    end
    -- TODO: infer bounding types based upon object types
    -- circle/rect/line
  elseif type == 'box' then
    -- use AABB (or other type of?) bounding boxes
  elseif type == 'perfect' then

  end
end


-- TODO: need to call love's getColor and then setColor back to before after calling
-- each method. see IMG(...) below for code that does this

-- TODO: fixed pallette? rgb?
-- TODO: choose a set of pallete presets?
-- TODO: see ayla/paul's infra-code
local function setColor(col)
  if col == nil then
    -- TODO: throw some error/warning
    col = {1,1,1}
  end

  if currThemeColors[col] then
    col = currThemeColors[col]
  end

  love.graphics.setColor(col[1], col[2], col[3], 1.0)
end

-- TODO: use size and font
-- TODO: pre-fetch font in load
function TEXT(message, x, y, scale, color, font)
  if message ~= nil then
    setColor(color)
    love.graphics.print(message, x, y, 0, scale, scale)
  end
end

local function drawRect(type, x1, y1, x2, y2, color)
  local x = x1
  local y = y1
  if x2 < x1 then x = x2 end
  if y2 < y1 then y = y2 end

  local w = math.abs(x1 - x2)
  local h = math.abs(y1 - y2)

  setColor(color)
  love.graphics.rectangle(type, x, y, w, h)
end

-- TODO: make all sorts of 
local entities = {}

function MAKE_RECT(x1, y1, x2, y2)
  local xA, yA, xB, yB = x1, y1, x2, y2

  local objectID = #entities

  local newRect = {
    id = objectID,
    type = 'rect',
    x1 = xA,
    y1 = yA,
    x2 = xB,
    y2 = yB
  }

  entities[objectID] = newRect

  return newRect
end

function RECT(x1, y1, x2, y2, color)
  drawRect('line', x1, y1, x2, y2, color)
end

function RECTFILL(x1, y1, x2, y2, color)
  drawRect('fill', x1, y1, x2, y2, color)
end

local function drawCircle(type, x, y, r, color)
  setColor(color)
  -- TODO: base number of segments on radius so it's always smooth,
  -- and also always as performant as possible
  love.graphics.circle(type, x, y, r, 128)
end

function CIRC(x, y, r, color)
  drawCircle('line', x, y, r, color)
end

function CIRCFILL(x, y, r, color)
  if theme == 'sketch' then
    drawCircle('fill', x, y, r, color)
    -- draw an outline brighter than the orig color
    if currThemeColors[color] then
      color = currThemeColors[color]
    end
    color[1] = math.min(color[1] + 0.5 * (1.0 - color[1]), 1.0)
    color[2] = math.min(color[2] + 0.5 * (1.0 - color[2]), 1.0)
    color[3] = math.min(color[3] + 0.5 * (1.0 - color[3]), 1.0)
    drawCircle('line', x, y, r, color)
  else
    drawCircle('fill', x, y, r, color)
  end
end

function LINE(x1, y1, x2, y2, color)
  local prevWidth = love.graphics.getLineWidth()
  if theme == 'retro' then
    love.graphics.setLineWidth(3.0)
  elseif theme == 'gameboy' then
    love.graphics.setLineWidth(4.0)
  elseif theme == 'virtualboy' then
    love.graphics.setLineWidth(4.0)
  end
  setColor(color)
  love.graphics.line(x1, y1, x2, y2)
  love.graphics.setLineWidth(prevWidth)
end

-- TODO: bugged. set exact point somehow
function PSET(x, y, color)
  local prevSize = love.graphics.getPointSize()
  if theme == 'retro' then
    love.graphics.setPointSize(3.0)
  elseif theme == 'gameboy' then
    love.graphics.setPointSize(6.0)
  elseif theme == 'virtualboy' then
    love.graphics.setPointSize(3.0)
  end
  setColor(color)
  love.graphics.points({x, y})
  love.graphics.setPointSize(prevSize)
end

function PSETS(pts, color)
  local prevSize = love.graphics.getPointSize()
  if theme == 'retro' then
    love.graphics.setPointSize(3.0)
  elseif theme == 'gameboy' then
    love.graphics.setPointSize(6.0)
  elseif theme == 'virtualboy' then
    love.graphics.setPointSize(3.0)
  end
  setColor(color)
  love.graphics.points(pts)
  love.graphics.setPointSize(prevSize)
end

function PGET(x, y) 
  -- TODO(jason): this one is important
end

-- TODO: supplying filename needs to create image at load-time automatically
-- and this function needs to lookup that love2d image in a table
-- and then draw that image according to the below params
-- TODO: define + use types for 'aspect' param
function IMG(filename, x1, y1, x2, y2, aspect)
  r,g,b,a = love.graphics.getColor()

  if Imgs[filename] then
    love.graphics.setColor(1,1,1,1)

    local actualWidth = Imgs[filename]:getWidth()
    local actualHeight = Imgs[filename]:getHeight()

    -- default aspect == stretch_to_fill
    local targetWidth = ABS(x2 - x1)
    local targetHeight = ABS(y2 - y1)

    if aspect == 'aspect_fill' then
      if actualWidth > targetWidth and actualHeight > targetHeight then
        if targetWidth/targetHeight > actualWidth/actualHeight then
          targetWidth = targetHeight * (actualWidth/actualHeight)
          x1 = x1 + ABS(x2 - x1) / 2 - targetWidth / 2
        else
          targetHeight = targetWidth * (actualHeight/actualWidth)
          y1 = y1 + ABS(y2 - y1) / 2 - targetHeight / 2
        end
      elseif actualWidth > targetWidth then
        targetHeight = targetWidth * (actualHeight/actualWidth)
        y1 = y1 + ABS(y2 - y1) / 2 - targetHeight / 2
      elseif actualHeight > targetHeight then
        targetWidth = targetHeight * (actualWidth/actualHeight)
        x1 = x1 + ABS(x2 - x1) / 2 - targetWidth / 2
      end
    end

    local xScaleFactor = targetWidth / actualWidth
    local yScaleFactor = targetHeight / actualHeight

    love.graphics.draw(Imgs[filename], x1, y1, 0, xScaleFactor, yScaleFactor, 0, 0)
  end

  love.graphics.setColor({r,g,b,a})
end

function AVATAR(x1, y1, x2, y2, aspect)
  if user.avatarImage then
    IMG('avatar', x1, y1, x2, y2, aspect)
  else
    -- TODO: throw warning?
  end
end

function USERNAME()
  if user.name then 
    return user.name
  end
end


-- TODO(use ayla's sprite sheets?)
function SPRITE(filename, index, x, y, numberOfSprites, flipHorizontal, flipVertical)

end

-- TODO: pre-fetch all sounds ever played, load them into sound engine
-- with a default volume and other params. if sound is larger than a
-- certain filesize... maybe set it to stream, rather than static?
-- can we intuit this somehow?

-- TODO: volume prob not need to be passed every time...
-- TODO: make volume+looping optional params
-- TODO: allow an onFinishFunc per sound
-- TODO: dig deep inside love, NEED to make looping seamless
-- TODO: need to allow filtering and some other things OpenAL provides
-- TODO: prob need additional C-level DSP stuff
function PLAYSND(filename, volume, shouldLoop)
  if Sounds[filename] then
    Sounds[filename]:setVolume(volume)
    Sounds[filename]:setLooping(shouldLoop)
    Sounds[filename]:play()
  end
end

function VOLUME(filename, volume)
  -- TODO: throw warning if volume outside of range?
  -- silently clamping for now
  if filename == 'theme' then
    filename = currMusic
  end

  volume = CLAMP(0.0, volume, 1.0)
  if Sounds[filename] then
    Sounds[filename]:setVolume(volume)
  end
end

-- TODO: pause actual sound passed in
function PAUSESND(filename)
  if Sounds[filename] then
    Sounds[filename]:pause()
  end
end

-- TODO: stop actual sound passed in
function STOPSND(filename)
  if Sounds[filename] then
    Sounds[filename]:stop()
  end
end

-- TODO: combine two below SRAND funcs via optional param?

-- Allow specific seeds
function SRAND(x) math.randomseed(x) end
-- Seeds randomly
function SRAND()
  -- bit-level trick from: http://lua-users.org/wiki/MathLibraryTutorial
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
end

function CLAMP(min, val, max)
  if min > max then 
    min, max = max, min 
  end
  return math.max(min, math.min(max, val))
end

function FLR(a) return math.floor(a) end
function DEG(a) return math.deg(a) end
function RAD(a) return math.rad(a) end
function CEIL(a) return math.ceil(a) end
-- TODO: can condense below two RAND funcs
function RAND() return math.random() end
function RAND(a, b) return math.random(a, b) end
function ABS(a, b) return math.abs(a, b) end
function SQRT(a) return math.sqrt(a) end
function LOG(x) return math.log(x) end
function EXP(x) return math.exp(x) end
function POW(x) return math.pow(x) end
function SIN(x) return math.sin(x) end
function COS(x) return math.cos(x) end
function TAN(x) return math.tan(x) end
function ASIN(x) return math.asin(x) end
function ACOS(x) return math.acos(x) end
function ATAN(x) return math.atan(x) end
function ATAN2(x, y) return math.atan2(y, x) end
function PI() return math.pi end

-- TODO: make MIN take variable-length list of args
-- see how math.min works - it already does that
function MIN(nums)
  return math.min(nums)
end

-- TODO: make work with variable-length list of args
function AVG(nums)
end

