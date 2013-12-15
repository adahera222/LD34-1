local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'
local Tween = require 'lib.tween.tween'

local Title = require 'src.states.title'

function love.load()
    local font =
        love.graphics.setFont(
            love.graphics.newFont('assets/fonts/Minercraftory.ttf'))

    Gamestate.registerEvents()
    Gamestate.switch(Title)
end

function love.update(dt)
    Timer.update(dt)
    Tween.update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end
