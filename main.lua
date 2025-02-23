love.window.setMode(800, 600)

local carCoord = {100,450}
local state = 1
local current = 1
local current2 = 1
local numbers = {
0,
"e^i(pi)",
"6.02214*10^-23",
"1.6180339887498948482",
"3.1415926535897932384626433", 
42,
80085,
299792458, 
"9223372036854775807", 
"01123581321345589144", 
"69!"}

local lines = {}
local numLines = 1000 -- Number of lines
local startY = love.graphics.getHeight() / 2
local delay = 0.35 -- Delay in seconds between each line
local speed = 1
local areas = {}
local timesOfDay = {}

--Cheese Squad
local cheeseScale = 0.001
local cheeseTimer = 10
local cheeseReplacement = {}
local cheeseCounter = 1
local cheeseScore = 0


function love.keypressed(key, scancode, isrepeat)
  if key == "right" then
    state = state + 1
  elseif key == "left" then
    state = state - 1
  elseif key == "escape" then
    love.event.quit()
  end
  if state > 2 then
    state = 2
  elseif state < 1 then
    state = 1
  end
end

function love.load()
  -- background/road colour
  love.graphics.setBackgroundColor(0.3, 0.3, 0.3)     
  -- Initialize lines with a delay
  for i = 1, numLines do
    table.insert(lines, {y = startY, width = 1, height = 1, delay = (i - 1) * delay, active = false})
  end
  
  -- Load images for areas
  --ground
  areas[1] = love.graphics.newImage("assets/side of road5.png")
  areas[2] = love.graphics.newImage("assets/side of road4.png")
  areas[3] = love.graphics.newImage("assets/side of road6.png")
  areas[4] = love.graphics.newImage("assets/side of road7.png")
  --sky
  timesOfDay[1] = love.graphics.newImage("assets/day1.png")
  timesOfDay[2] = love.graphics.newImage("assets/night1.png")
  timesOfDay[3] = love.graphics.newImage("assets/darknight1.png")
  -- Car
  car = love.graphics.newImage("assets/forward.png")
  -- Cheese Mayhem
  for i = 1,13 do
    cheeseReplacement[i] = {love.graphics.newImage("assets/Slide"..i..".png"),0}
  end
  cheeseReplacement[1][2], cheeseReplacement[2][2], cheeseReplacement[10][2],cheeseReplacement[11][2] = 1,1,1,1
  cheeseReplacement[5][2], cheeseReplacement[12][2], cheeseReplacement[13][2] = 2,2,2
  --trophy
  trophy = love.graphics.newImage("assets/hooray.jpg")
end

 
function love.draw()
  -- draw road
  local screenWidth = love.graphics.getWidth()
  for _, line in ipairs(lines) do
    if line.active then
      -- Draw the grey sides
      love.graphics.setColor(0.2, 0.2, 0.2)
      love.graphics.setLineWidth(line.width)
      love.graphics.rectangle("fill", 0, line.y - line.height / 2, screenWidth, line.height)
      -- Draw the yellow trapezium
      local yellowWidth = line.width * 0.5 -- Adjust yellow width
      local yellowHeight = line.height * 1.0 -- Adjust yellow height
      local yellowStartX = (screenWidth - yellowWidth) / 2
      local yellowStartY = line.y - yellowHeight / 2
      love.graphics.setColor(1, 1, 0)
      love.graphics.polygon("fill", 
        yellowStartX, yellowStartY,
        yellowStartX + yellowWidth, yellowStartY,
        yellowStartX + yellowWidth * 1.2, yellowStartY + yellowHeight,
        yellowStartX - yellowWidth * 0.2, yellowStartY + yellowHeight
      )
    end
  end
  love.graphics.setColor(1, 1, 1) 
  --draw car
  love.graphics.draw(car, carCoord[1], carCoord[2])
  --draw background
  if cheeseTimer < 0 then
    current = math.random(3)
    current2 = math.random(4)
    cheeseTimer = 10
    local carPos = 0
    if carCoord[1]+1 < 400 then
      carPos = 1
    end
    if cheeseCounter < 14 then
      if carPos == cheeseReplacement[cheeseCounter][2] then
        cheeseScore = cheeseScore + 1
      end
    end
    --change displayNum
    displayNum = math.random(2, 12)
    if cheeseCounter ~= 14 then
      cheeseCounter = cheeseCounter + 1
    end
  end
  --background
  love.graphics.draw(timesOfDay[current], 0, 0)
  love.graphics.draw(areas[current2], 0, 180, 0, 2, 1.8)
  --cheese banner
  if (cheeseTimer > 0 and cheeseTimer < 5 and cheeseCounter ~= 14) then
    love.graphics.setLineWidth(20)
    love.graphics.setColor(1-cheeseTimer/5,1*cheeseTimer/5,0)
    love.graphics.line(800*(cheeseTimer/5),0,0,0)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Y",20,350,0,10)
    love.graphics.print("N",680,350,0,10)
    love.graphics.draw(cheeseReplacement[cheeseCounter][1],400-(720*cheeseScale/2),240-(405*cheeseScale/2),0,cheeseScale)
  else
    cheeseScale = 0.002
  end
  --display "insurance cost"
  love.graphics.print("Insurance: £"..numbers[11-cheeseScore], 40, 20)
  --the end times
  if cheeseCounter == 14 then
    love.graphics.clear()
    love.graphics.draw(trophy, 275, 10)
    love.graphics.print("Insurance: £10000000000000000000000000000000000000000000000000000000000000000000000000000", 10, 300)
  end
end

function love.update(dt)
  local screenHeight = love.graphics.getHeight()
  for _, line in ipairs(lines) do
    if line.delay > 0 then
      line.delay = line.delay - dt
      if line.delay <= 0 then
        line.active = true
      end
    end
    if line.active then
      if line.y < screenHeight then
        line.y = line.y + speed * 250 * dt -- Speed of the line moving down
        line.width = line.width + speed * 30 * dt -- Speed of the line getting thicker
        line.height = line.height + speed * 30 * dt -- Speed of the line getting taller
      else
        -- Reset line to the middle of the screen
        line.y = startY
        line.width = 1
        line.height = 1
        line.delay = delay * numLines 
        line.active = false
      end
    end
  end
  --car movement
  if state == 1 and carCoord[1]> 100 then
    carCoord[1] = carCoord[1] - 1
  elseif state == 2 and carCoord[1] < 500 then
    carCoord[1] = carCoord[1] + 1
  end
  --cheese banner
  if (cheeseScale < 0.3)
  then
    cheeseScale = cheeseScale + 0.002
  end
  cheeseTimer = cheeseTimer - dt
end
