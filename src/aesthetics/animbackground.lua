local lg = love.graphics

local Class = require 'lib.hump.class'
local Tween = require 'lib.tween.tween'
local Vector = require 'lib.hump.vector'

local function convert(ms, size)
    local r, c = 0, 0
    local grid = {}

    for line in ms:gmatch'[^\n]+' do
        c = 0
        grid[r] = {}

        for ch in line:gmatch'%d' do
            grid[r][c] = {
                x = c * size,
                y = r * size,
                w = size,
                h = size,
                filled = tonumber(ch) == 1
            }

            c = c + 1
        end

        r = r + 1
    end

    return grid
end

local AnimatedBackground = Class{}
function AnimatedBackground:init(rows, columns, size, ms)
    self.rows = rows
    self.columns = columns
    self.size = size
    self.dimensions = Vector(columns * size, rows * size)

    if ms then
        self._grid = convert(ms, self.size)
    else
        self._grid = {}
        for r = 0, self.rows - 1 do
            self._grid[r] = {}
            for c = 0, self.columns - 1 do
                self._grid[r][c] = {
                    x = c * self.size,
                    y = r * self.size,
                    w = self.size,
                    h = self.size,
                    filled = true,
                }
            end
        end
    end
end

function AnimatedBackground:start()
    for r = 0, self.rows - 1 do
        for c = 0, self.columns - 1 do
            self._grid[r][c].x = -self.size
            Tween(
                4 + (c * 0.15),
                self._grid[r][c],
                { x = c * self.size },
                'inOutBounce')
        end
    end
end

function AnimatedBackground:draw()
    for r = 0, self.rows - 1 do
        for c = 0, self.columns - 1 do
            local rect = self._grid[r][c]

            if rect.filled then
                lg.setColor(255, 255, 255)
            else
                lg.setColor(0, 0, 0)
            end

            lg.rectangle(
                'fill',
                rect.x + 1,
                rect.y + 1,
                rect.w - 2,
                rect.h - 2)
        end
    end
end

return AnimatedBackground
