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
    self._bars = {
        vertical = -10,
        horizontal = -10,
    }
end

function Background:update(dt)
    self._bars.vertical =
        self._bars.vertical + 100 * dt
    self._bars.horizontal =
        self._bars.horizontal + 100 * dt

    if self._bars.vertical > lg.getWidth() then
        self._bars.vertical = -10
    end

    if self._bars.horizontal > lg.getHeight() then
        self._bars.horizontal = -10
    end
end

function Background:draw()
    lg.setLineWidth(5)

    lg.setColor(0, 255, 0)
    lg.line(
        self._bars.vertical, 0,
        self._bars.vertical, lg.getHeight())
    lg.line(
        0, self._bars.horizontal,
        lg.getWidth(), self._bars.horizontal)

    lg.setColor(255, 255, 255)
    lg.draw(self._canvas)
end

return Background
