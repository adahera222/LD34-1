local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local function convert(ms)
    local r, c = 0, 0
    local grid = {}

    for line in ms:gmatch'[^\n]+' do
        c = 0
        grid[r] = {}

        for ch in line:gmatch'%d' do
            grid[r][c] = tonumber(ch) == 1

            c = c + 1
        end

        r = r + 1
    end

    return grid, r, c
end

local Screen = Class{}
function Screen:init(ms, size, x, y)
    local grid, rows, columns = convert(ms)

    self.position = Vector(x, y)
    self.dimensions = Vector(rows, columns)
    self.ms = ms
    self.size = size
    self._grid = grid
    self.repeats = {}
end

function Screen:setPosition(x, y)
    self.position = Vector(x, y)
end

function Screen:isComplete()
    for r = 0, self.dimensions.x - 1 do
        for c = 0, self.dimensions.y - 1 do
            if not self._grid[r][c] then
                return false
            end
        end
    end

    return true, #self.repeats
end

function Screen:applyPlank(plank)
    -- Clone the plank position
    local ppos = plank.position:clone()
    local pw, ph = plank:getTetrominoDimensions()

    -- Offset the plank position by the screen position
    ppos = ppos - self.position

    local pc = math.floor((ppos.x - pw / 2) / self.size)
    local pr = math.floor((ppos.y - ph / 2) / self.size)

    for r = 0, 1 do
        for c = 0, 3 do
            if plank.grid[r][c] then
                local nr, nc = plank:transformCoordinates(r, c)

                if self._grid[pr + nr][pc + nc] then
                    table.insert(self.repeats, Vector(pr + nr, pc + nc))
                end

                self._grid[pr + nr][pc + nc] = true
            end
        end
    end
end

function Screen:draw()
    lg.setLineWidth(1)

    for r = 0, self.dimensions.x - 1 do
        for c = 0, self.dimensions.y - 1 do
            if self._grid[r][c] then
                lg.setColor(255, 255, 255)
            else
                lg.setColor(0, 0, 0)
            end

            lg.rectangle(
                'fill',
                (self.position.x + c * self.size) - 1,
                (self.position.y + r * self.size) - 1,
                self.size - 2,
                self.size - 2)
        end
    end

    for _,v in ipairs(self.repeats) do
        lg.setColor(0, 0, 255)
        lg.rectangle(
            'fill',
            (self.position.x + v.y * self.size) - 1,
            (self.position.y + v.x * self.size) - 1,
            self.size - 2,
            self.size - 2)
    end
end

return Screen
