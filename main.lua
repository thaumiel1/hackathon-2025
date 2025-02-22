love.window.setMode(800, 600)
local carx = 100
local cary = 450
local state = 1
local current = 0
local area = 0
local lines = {}
local numLines = 1000 -- Number of lines
local startY = love.graphics.getHeight() / 2
local delay = 0.35 -- Delay in seconds between each line
local speed = 1
local timer = 0
local stopTimer = false
local trueTimer = 0
local cheeseScale = 0.001
local cheeseTimer = 5
local cheeseWizz = 0 --radians go brrrrr
local showCheese = false


function love.keypressed( key, scancode, isrepeat )
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
  --backgrounds ground
  grass = love.graphics.newImage("assets/side of road4.png")
  dessert = love.graphics.newImage("assets/side of road5.png")
  sea = love.graphics.newImage("assets/side of road6.png")
  city = love.graphics.newImage("assets/side of road7.png")
  --backgrounds sky
  day = love.graphics.newImage("assets/day1.png")
  night = love.graphics.newImage("assets/night1.png")
  darkNight = love.graphics.newImage("assets/darknight1.png")
  --car
  car = love.graphics.newImage("assets/forward.png")
  cheese = love.graphics.newImage("assets/cheese.jpg")
end

function love.draw()
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
    --love.graphics.draw(grass, 0, 180, 0, 2, 1.8)
  love.graphics.draw(car, carx, cary)
  
  --background
  if current == 0  and area == 0 then
    current = day
    area = grass
  end
  choose = math.random(1, 5000)
  if choose == 300 then
    current = day
  elseif choose == 4000 then
    current = night
  elseif choose == 1000 then
    current = darkNight
  elseif choose == 3333 then
    area = grass
  elseif choose == 1111 then
    area = dessert
  elseif choose == 1 then
    area = sea
  elseif choose == 3278 then
    area = city
  end
  love.graphics.draw(current, 0, 0)
  love.graphics.draw(area, 0, 180, 0, 2, 1.8)
  love.graphics.print(choose, 100, 100)

  if state == 1 then
    love.graphics.print("LEFT", 300, 100)
  elseif state == 2 then
    love.graphics.print("RIGHT", 300, 100)
  end
 
  --cheese banner
  if (cheeseTimer > 0)
  then
    if (showCheese == true)
    then
      love.graphics.draw(cheese,360,240,cheeseWizz,cheeseScale)
    end
  else
    cheeseTimer = 5
    cheeseScale = 0.002
    showCheese = not showCheese
  end
  --timer
  love.graphics.print("Timer: " .. timer,40,20)
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
                -- Reset the line to the middle of the screen
                line.y = startY
                line.width = 1
                line.height = 1
                line.delay = delay * numLines 
                line.active = false
            end
        end
    end
  
  if state == 1 and carx > 100 then
    carx = carx - 1
  elseif state == 2 and carx < 500 then
    carx = carx + 1
  end

  --cheese banner
  if (cheeseScale < 0.3)
  then
    cheeseScale = cheeseScale + 0.002
  end


  -- Timer that stops if t is pressed
  if (love.keyboard.isDown('t'))
  then
      stopTimer = true
  end
  if (stopTimer == false)
  then
      trueTimer = trueTimer + dt
      timer = math.floor(trueTimer)
      cheeseTimer = cheeseTimer - dt
  end
end
