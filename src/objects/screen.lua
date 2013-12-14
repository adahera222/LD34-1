local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local function createGrid(x, y, rows, columns, size)
    local grid = {}

    for r = 0, rows - 1 do
        grid[r] = {}

        for c = 0, columns - 1 do
            grid[r][c] = false
        end
    end

    return grid
end

local Screen = Class{}
function Screen:init(rows, columns, size, x, y)
    self.position = Vector(x or 0, y or 0)
    self.dimensions = Vector(rows, columns)
    self.size = size
    self._grid = createGrid(
        self.position.x,
        self.position.y,
        rows,
        columns,
        size)
    self.repeats = {}
end

function Screen:set(hs)
    local r, c = 0, 0

    for line in hs:gmatch('[^\n]+') do
        c = 0

        for ch in line:gmatch('%d') do
            self._grid[r][c] = tonumber(ch) == 1

            c = c + 1
        end

        r = r + 1
    end

    --[[
    self._canvas:renderTo(function ()
        for r = 0, self.dimensions.x - 1 do
            for c = 0, self.dimensions.y - 1 do
                if self._grid[r][c] then
                    lg.setColor(255, 255, 255)
                    lg.rectangle(
                        'fill',
                        c * self.size,
                        r * self.size,
                        self.size,
                        self.size)
                end

                lg.setColor(100, 100, 100)
                lg.rectangle(
                    'line',
                    c * self.size,
                    r * self.size,
                    self.size,
                    self.size)
            end
        end
    end)
    ]]
end

function Screen:applyPlank(plank)
    -- Clone the plank position
    local ppos = plank.position:clone()
    local pw, ph = plank:getDimensions()

    -- Offset the plank position by the screen position
    ppos = ppos - self.position

    local pc = math.floor((ppos.x - pw / 2) / self.size)
    local pr = math.floor((ppos.y - ph / 2) / self.size)

    for r = 0, 1 do
        for c = 0, 3 do
            if plank.grid[r][c] then
                local nr, nc = plank:rotateCoordinates(r, c)

                if self._grid[pr + nr][pc + nc] then
                    table.insert(self.repeats, Vector(pr + nr, pc + nc))
                end

                self._grid[pr + nr][pc + nc] = true
            end
        end
    end
end

function Screen:draw()
    --lg.draw(self._canvas, self.position.x, self.position.y)

    for r = 0, self.dimensions.x - 1 do
        for c = 0, self.dimensions.y - 1 do
            if self._grid[r][c] then
                lg.setColor(255, 255, 255)
            else
                lg.setColor(0, 0, 0)
            end

            lg.rectangle(
                'fill',
                c * self.size,
                r * self.size,
                self.size,
                self.size)
        end
    end

    for _,v in ipairs(self.repeats) do
        lg.setColor(0, 0, 255)
        lg.rectangle(
            'fill',
            v.y * self.size,
            v.x * self.size,
            self.size,
            self.size)
    end

    for r = 0, self.dimensions.x - 1 do
        for c = 0, self.dimensions.y - 1 do
            lg.setColor(100, 100, 100)
            lg.rectangle(
                'line',
                c * self.size,
                r * self.size,
                self.size,
                self.size)
        end
    end
end

return Screen
