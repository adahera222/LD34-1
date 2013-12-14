local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'

local Play = require 'src.states.play'

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Play)
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end
