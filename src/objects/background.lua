local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local function createCanvas(rows, columns, size)
    local canvas = lg.newCanvas(columns * size, rows * size)

    canvas:renderTo(function ()
        for r = 0, rows - 1 do
            for c = 0, columns - 1 do
                lg.rectangle(
                    'fill',
                    (c * size) - 1,
                    (r * size) - 1,
                    size - 2,
                    size - 2)
            end
        end
    end)

    return canvas
end

local Background = Class{}
function Background:init(rows, columns, size)
    self.rows = rows
    self.columns = columns
    self.dimensions = Vector(columns * size, rows * size)
    self.size = size
    self._canvas = createCanvas(rows, columns, size)
end

function Background:draw()
    lg.setColor(255, 255, 255)
    lg.draw(self._canvas)
end

return Background
