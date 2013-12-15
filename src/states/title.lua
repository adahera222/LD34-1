local lg = love.graphics

local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'
local Tween = require 'lib.tween.tween'

local AnimatedBackground = require 'src.aesthetics.animbackground'
local Play = require 'src.states.play'

local Title = {}

function Title:init()
    self.abg = AnimatedBackground(
        math.ceil(lg.getHeight() / 20),
        math.ceil(lg.getWidth() / 20),
        20,
        [[11111111111111111111
          11111111111111111111
          11100001000000110111
          11101110110110110111
          11100001110110000111
          11101111110110110111
          11101111110110110111
          11111111111111111111
          11111111111111111111
          11111100000000111111
          11111100000000111111
          11111111111111111111
          11111100000000111111
          11111100000000111111
          11111111111111111111
          11111100000000111111
          11111100000000111111
          11111111111111111111
          11111111111111111111
          11111111111111111111]])
          -- 120, 180

    self.plates = {
        { x = 120, y = 180, w = 160, h = 40 },
        { x = 120, y = 240, w = 160, h = 40 },
        { x = 120, y = 300, w = 160, h = 40 },
    }

    self.fontColor = { 255, 255, 255, 0 }

    self.font = lg.getFont()
end

function Title:enter(previous, ...)
    self.abg:start()
    -- 5.5
    Timer.add(5.5, function ()
        Tween(3, self.fontColor, { 255, 255, 255, 255 })
    end)
end

function Title:leave()
end

function Title:update(dt)
end

function Title:draw()
    self.abg:draw()

    lg.setColor(self.fontColor)
    lg.printf('Play', self.plates[1].x, self.plates[1].y + (self.plates[1].h / 3), self.plates[1].w, 'center')
    lg.printf('Tutorial', self.plates[2].x, self.plates[2].y + (self.plates[2].h / 3), self.plates[2].w, 'center')
    lg.printf('Quit', self.plates[3].x, self.plates[3].y + (self.plates[3].h / 3), self.plates[3].w, 'center')
end

function Title:focus()
end

function Title:keypressed(key, code)
    if key == ' ' then
        Gamestate.switch(Play)
    end
end

function Title:keyreleased(key, code)
end

function Title:mousepressed(x, y, button)
end

function Title:mousereleased(x, y, button)
end

function Title:quit()
end

return Title
