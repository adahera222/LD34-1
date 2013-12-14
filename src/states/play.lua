local lg = love.graphics
local lm = love.mouse

local Gamestate = require 'lib.hump.gamestate'

local Background = require 'src.objects.background'
local Plank = require 'src.objects.plank'
local Screen = require 'src.objects.screen'

local Choose = require 'src.states.choose'

local Play = {}

function Play:init()
end

function Play:enter(previous, plank)
    print('Entering Play...')

    self.background = Background(
        math.ceil(lg.getHeight() / 30),
        math.ceil(lg.getWidth() / 30),
        30)

    self.screen = Screen([[
        1111111111
        1101110001
        1000100011
        1000000011
        1100000001
        1100000001
        1110000001
        1100000001
        1110000111
        1111111111]], 30, 60, 60)

    Gamestate.push(Choose, self.screen.ms, self.background)
end

function Play:leave()
    print('Leaving Play...')
end

function Play:update(dt)
    self.plank:setPosition(lm.getX(), lm.getY())
    self.background:update(dt)
end

function Play:draw()
    self.background:draw()
    self.screen:draw()
    self.plank:draw()
end

function Play:focus()
end

function Play:keypressed(key, code)
    self.plank:keypressed(key, code)
end

function Play:keyreleased(key, code)
end

function Play:mousepressed(x, y, button)
    self.screen:applyPlank(self.plank)
end

function Play:mousereleased(x, y, button)
end

function Play:quit()
end

function Play:setPlank(ps)
    self.plank = Plank(
        lm.getX(),
        lm.getY(),
        self.screen.size,
        ps)
end

return Play
