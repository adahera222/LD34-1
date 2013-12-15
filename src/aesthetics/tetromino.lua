local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local Tetromino = Class{}
function Tetromino:init(x, y, width, height, ps)
    self.position = Vector(x, y)
    self.width = width
    self.height = height
    self.rows = 2
    self.columns = 4
    self.ps = ps
    self.canvas = lg.newCanvas(
        self.width * 4,
        self.height * 2)

    self.canvas:renderTo(function ()
        local r, c = 0, 0

        for line in ps:gmatch'[^\n]+' do
            c = 0
            for ch in line:gmatch'%d' do
                if tonumber(ch) == 1 then
                    lg.rectangle(
                        'fill',
                        c * self.width,
                        r * self.height,
                        self.width,
                        self.height)
                end
                c = c + 1
            end
            r = r + 1
        end
    end)
end

function Tetromino:getBoundingBox()
    return
        self.position.x,
        self.position.y,
        self.canvas:getWidth(),
        self.canvas:getHeight()
end

function Tetromino:draw()
    lg.draw(
        self.canvas,
        self.position.x,
        self.position.y)
end

return Tetromino
