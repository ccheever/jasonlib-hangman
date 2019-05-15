require 'lib'

local horizLineYVals = {}
local trigPts = {}
local lastLineSpawnTime = 0
local playerX = 0
local shouldTheme = true
local currTheme = 'retro'

local box1 = nil
local box2 = nil

function updateTheme()
  if shouldTheme then
    THEME(currTheme)
  else 
    THEME('none')
  end
end

function _LOAD()
  SRAND()
  
  THEME(currTheme)
  VOLUME('theme', 1.0)
  updateTheme()

  -- seed horiz lines
  for i = 1, 200 do
    local val = 5.0
    for i = 1, i do
      val = val + val * val * 0.005
    end
    horizLineYVals[i] = val
  end

  box1 = MAKE_RECT(0,0,10,10)
  box2 = MAKE_RECT(20,20,40,40)
end

function _DRAW()
  -- bg
  if currTheme == 'retro' then
    RECTFILL(0, 0, W(), H(), {0.05, 0.05, 0.15})
  else
    RECTFILL(0, 0, W(), H(), 'black')
  end

  -- stars
  for i = 1, 256 do
    local x = RAND(0, W())
    local y = RAND(0, H()/2)
    PSET(x, y, 'white')
  end

  PSETS(trigPts, 'cyan') -- trig function aurora
  CIRCFILL(W()/2, H()/2 + H()/10, W()/6, 'orange') -- sun
  -- ground bg
  if theme == 'retro' then
    RECTFILL(0, H()/2, W(), H(), {0.1, 0.1, 0.1})
  elseif theme == 'gameboy' then
    RECTFILL(0, H()/2, W(), H(), 'black')
  else
    RECTFILL(0, H()/2, W(), H(), {0.1, 0.1, 0.1})
  end

  -- horiz lines
  local yHorizon = H()/2
  for i, y in ipairs(horizLineYVals) do
    local brightness = 0.65 + 0.35 * (y / yHorizon)
    if currTheme == 'retro' then
      LINE(0, y + yHorizon, W(), y + yHorizon, { brightness * 1.0, 0.0, brightness * 1.0 })
    else
      LINE(0, y + yHorizon, W(), y + yHorizon, 'purple')
    end
  end
  LINE(0, yHorizon, W(), yHorizon, 'purple')

  -- vert lines
  for i = -W() * 8 + playerX, W() + 8 * W() + playerX, W() / 3 do
    local vanishY = H() / 2 - H() / 40
    local m = (vanishY - H()) / (W()/2 - i)
    local xHorizon = (yHorizon - H())/m + i
    LINE(i, H(), xHorizon, H()/2, 'purple')
  end

  -- TOP LEFT OBJECTS
  TEXT(USERNAME(), 20, 10, 2, 'white', 'Arial')

  RECT(20, 50, 70, 100, 'green')
  CIRC(45, 75, 16, 'red')
  RECTFILL(90, 50, 140, 100, 'cyan')
  AVATAR(160, 50, 210, 100, 'aspect_fill')

  -- boxes
  --RECTFILL(box1.x1, box1.y1, box1.x2, box1.y2, 'green')
  --RECTFILL(box2.x1, box2.y1, box2.x2, box2.y2, 'green')
end

function _UPDATE(dt)
  -- horiz lines
  for i = 1, #horizLineYVals do
    horizLineYVals[i] = horizLineYVals[i] + (horizLineYVals[i] * horizLineYVals[i] * 0.01 * dt)
    if T() - lastLineSpawnTime > 0.4 then
      horizLineYVals[#horizLineYVals + 1] = 5.0
      lastLineSpawnTime = T()
    end
  end

  -- trig funcs
  trigPts = {}
  local xOffset = 0
  local yOffset = 150
  local amp = SIN(0.04 * T()) * 12 * COS(T() * 0.27) * 16
  local amp2 = 0.5 * COS(0.04 * T()) * 12 * COS(T() * 0.27) * 16
  local numPts = W()
  for i = 1, numPts do
    local x = i / 20.0 + T()
    local yWavyOffset = 4 * SIN(T()) * COS(T() * 2.7)
    trigPts[i] = {i + xOffset, yWavyOffset + amp * SIN(x * (1.0 + 0.5 * SIN(T()/5.0))) + yOffset}
    trigPts[i + numPts] = {i + xOffset, yWavyOffset + amp2 * SIN(x * (1.0 + 0.5 * SIN(T()/20.00))) + yOffset}
    trigPts[i + numPts * 2] = {i + xOffset, yWavyOffset + amp * TAN(x) + yOffset}
  end

  -- boxes
  --if COLLIDED(box1, box2, 'basic') then
    -- TODO: should allow this method?
    -- floatyBox:rewindOneFrame()
    -- TODO: make collision response easier from inside the lib?
    --box1.vx, floatyBox1.vy = -floatyBox1.vx, -floatyBox2.vy
    --floatyBox2.vx, floatyBox2.vy = -floatyBox2.vx, -floatyBox2.vy
  --casend

  -- player motion
  if BTN('left') or BTN('a') then
    playerX = playerX + 1024 * dt
  end

  if BTN('right') or BTN('d') then
    playerX = playerX - 1024 * dt
  end
  
  if BTN('space') then
    PLAYSND('fx.mp3', 0.0, true)
  end

  -- theme
  if BTNP('0') then
    shouldTheme = false
    updateTheme()
  elseif BTNP('1') then
    shouldTheme = true
    currTheme = 'retro'
    updateTheme()
  elseif BTNP('2') then
    shouldTheme = true
    currTheme = 'gameboy'
    updateTheme()
  elseif BTNP('3') then
    shouldTheme = true
    currTheme = 'sketch'
    updateTheme()
  elseif BTNP('4') then
    shouldTheme = true
    currTheme = 'virtualboy'
    updateTheme()
  elseif BTNP('5') then
    shouldTheme = true
    currTheme = 'lofi'
    updateTheme()
  elseif BTNP('6') then
    shouldTheme = true
    currTheme = 'cyber'
    updateTheme()
  end
end
