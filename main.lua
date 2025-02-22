var = 1 
x=1
speed = 0
y = 0
function love.keypressed( key, scancode, isrepeat )
  if key == "=" then
    var = var + 1
  elseif key == "-" then
    var = var - 1
  end
  if var > 9 then
    var = 9
  elseif var < 1 then
    var = 1
  end
  if key == "right" then
   speed = speed + 1
  end
  if key == "left" then
    speed = speed - 1
   end
end

function love.load()
	car = love.graphics.newImage("car.jpg")
end


function love.draw()
  love.graphics.print(speed, 300, 400)
  love.graphics.print(x, 100, 100)
  love.graphics.rectangle("fill", 50,20, 70,30)
  love.graphics.draw(car, x, y)
end

function love.update(dt)
  x = x +1 * speed

  if x > 500 then
   x = 0
  end
end