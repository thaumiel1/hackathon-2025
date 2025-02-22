love.window.setMode(800, 600)
carx = 100
cary = 500
state = 1

local lines = {}
local numLines = 1000 -- Number of lines
local startY = love.graphics.getHeight() / 2
local delay = 0.4 -- Delay in seconds between each line

function love.keypressed( key, scancode, isrepeat )
  if key == "right" then
   state = state + 1
  elseif key == "left" then
    state = state - 1
  elseif key == "escape" then
    love.event.quit()
  end
  if state > 3 then
    state = 3
  elseif state < 1 then
    state = 1
  end
end

function love.load()
  love.graphics.setBackgroundColor(0.3, 0.3, 0.3) -- Dark background for contrast
    
    -- Initialize lines with a delay
    for i = 1, numLines do
        table.insert(lines, {y = startY, width = 1, height = 1, delay = (i - 1) * delay, active = false})
    end
  sideofroad = love.graphics.newImage("assets/side of road2.png")

	car = love.graphics.newImage("assets/forward.png")
  day = love.graphics.newImage("assets/day1.png")
end

function love.draw()
  local screenWidth = love.graphics.getWidth()
    
    for _, line in ipairs(lines) do
        if line.active then
            -- Draw the grey sides
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.setLineWidth(line.width)
            love.graphics.rectangle("fill", 0, line.y - line.height / 2, screenWidth, line.height)

            -- Draw the yellow middle
            local yellowWidth = line.width * 0.5 -- Adjust the factor to control the width of the yellow part
            local yellowHeight = line.height * 1.0 -- Adjust the factor to control the height of the yellow part
            local yellowStartX = (screenWidth - yellowWidth) / 2
            local yellowStartY = line.y - yellowHeight / 2
            love.graphics.setColor(1, 1, 0)
            love.graphics.setLineWidth(yellowWidth)
            love.graphics.rectangle("fill", yellowStartX, yellowStartY, yellowWidth, yellowHeight)
        end
        love.graphics.draw(day, 0, 0)
    end
    
    love.graphics.setColor(1, 1, 1) 
    love.graphics.draw(sideofroad, 0, 180, 0, 2, 1.8)

  love.graphics.draw(car, carx, cary)
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
                line.y = line.y + 250 * dt -- Speed of the line moving down
                line.width = line.width + 30 * dt -- Speed of the line getting thicker
                line.height = line.height + 30 * dt -- Speed of the line getting taller
            else
                -- Reset the line to the middle of the screen
                line.y = startY
                line.width = 1
                line.height = 1
                line.delay = delay * numLines -- Reset the delay for the next cycle
                line.active = false
            end
        end
    end
  
  if state == 1 and carx > 100 then
    carx = carx - 1
  elseif state == 2 and carx > 300 then
    carx = carx - 1
  elseif state == 2 and carx < 300 then
    carx = carx + 1
  elseif state == 3 and carx < 600 then
    carx = carx + 1
  end
end
