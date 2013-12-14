local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local function convert(ms, size)
    local map = {}

    local rows = 0
    local columns = 0

    for line in ms:gmatch('[^\n]+') do
        rows = rows + 1

        map[rows] = {}

        for ch in line:gmatch('%d') do
            columns = columns + 1

            map[rows][columns] = {
                position = Vector((columns - 1) * size, (rows - 1) * size),
                coordinates = Vector(rows, columns),
                size = size,
                filled = ch == 1,
            }
        end

        columns = 0
    end
end

local Hole = Class{}
function Hole:init(x, y, size, ms)
    self.position = Vector(x, y)
    self.size = size
end
