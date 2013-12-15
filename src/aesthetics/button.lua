local lg = love.graphics
local lm = love.mouse

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local Button = Class{}
function Button:init(x, y, width, height, text, font)
    self.position = Vector(x, y)
    self.dimensions = Vector(width, height)
    self.font = font
    self.text = {
        str = text,
        x = self.position.x,
        y = self.position.y + (self.dimensions.y / 2 - self.font:getHeight(text) / 2),
        w = self.dimensions.x,
    }
    self.colors = {
        font = { 255, 255, 255, 255 },
        idle = { 0, 0, 0 },
        hover = { 100, 100, 100 },
        click = { 175, 175, 175 },
    }
    self.colors.current = self.colors.idle
    self.callback = function () error('Callback not set') end
end

function Button:setCallback(func)
    self.callback = func
end

function Button:update(dt)
    if self:within(lm.getPosition()) then
        if lm.isDown('l') then
            self.colors.current = self.colors.click
            self.callback()
        else
            self.colors.current = self.colors.hover
        end
    else
        self.colors.current = self.colors.idle
    end
end

function Button:within(x, y)
    return self.position.x <= x and
           self.position.x + self.dimensions.x >= x and
           self.position.y <= y and
           self.position.y + self.dimensions.y >= y
end

function Button:draw()
    lg.setColor(self.colors.current)
    lg.rectangle(
        'fill',
        self.position.x,
        self.position.y,
        self.dimensions.x,
        self.dimensions.y)

    lg.setColor(self.colors.font)
    lg.printf(
        self.text.str,
        self.text.x,
        self.text.y,
        self.text.w,
        'center')
end

return Button
