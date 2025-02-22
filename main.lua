love.window.setMode(800, 600)
carx = 100
cary = 500
state = 1
function love.keypressed( key, scancode, isrepeat )
  if key == "right" then
   state = state + 1
  elseif key == "left" then
    state = state - 1
  end
  if state > 3 then
    state = 3
  elseif state < 1 then
    state = 1
  end
end

function love.load()
	car = love.graphics.newImage("100x100forward.png")
end

function love.draw()
  love.graphics.draw(car, carx, cary)
 end

function love.update(dt)
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
