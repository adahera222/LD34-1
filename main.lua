local lg = love.graphics
local lm = love.mouse

local Screen = require 'src.objects.screen'
local Plank = require 'src.objects.plank'

function love.load()
    s = Screen(10, 10, 50)
    s:set[[
        1 1 1 1 1 1 1 1 1 1
        1 1 0 1 1 1 0 0 0 1
        1 0 0 0 1 0 0 0 1 1
        1 0 0 0 0 0 0 0 1 1
        1 1 0 0 0 0 0 0 0 1
        1 1 0 0 0 0 0 0 0 1
        1 1 1 0 0 0 0 0 0 1
        1 1 0 0 0 0 0 0 0 1
        1 1 1 0 0 0 0 1 1 1
        1 1 1 1 1 1 1 1 1 1]]

    p = Plank(lg.getWidth() / 2, lg.getHeight(), 50,
    [[1111
      1000]])
end

function love.update(dt)
    p.position.x = lm.getX()
    p.position.y = lm.getY()
end

function love.draw()
    lg.setColor(255, 255, 255)

    s:draw()
    p:draw()
end

function love.keypressed(key, code)
    if key == 'escape' then
        love.event.quit()
    end

    p:keypressed(key, code)
end

function love.mousepressed(x, y, button)
    s:applyPlank(p)
end
