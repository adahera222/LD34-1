local lg = love.graphics

local Class = require 'lib.hump.class'
local Tween = require 'lib.tween.tween'
local Vector = require 'lib.hump.vector'

local Screen = Class{}
function Screen:init(rows, columns, size, ms)
    self.rows = rows
    self.columns = columns
    self.size = size
    self.repeats = 0

    self._grid = {}
    --self._fakes = {}

    local r, c = 0, 0
    for line in ms:gmatch'[^\n]+' do
        c = 0

        self._grid[r] = {}

        for ch in line:gmatch'%d' do
            self._grid[r][c] = {
                x = c * self.size,
                y = r * self.size,
                w = self.size,
                h = self.size,
                color = { 255, 255, 255, 255 },
                filled = tonumber(ch) == 1,
            }

            if not self._grid[r][c].filled then
                self._grid[r][c].color = { 0, 0, 0, 255 }
                --[=[
                table.insert(self._fakes, {
                    x = c * self.size,
                    y = r * self.size,
                    w = self.size,
                    h = self.size,
                    color = { 255, 255, 255, 255 },
                })
                ]=]
            end

            c = c + 1
        end

        r = r + 1
    end
end

--[=[
function Screen:start()
    for _,v in ipairs(self._fakes) do
        local ny = v.y + lg.getHeight()
        Tween(
            math.random(1, 5),
            v,
            {
                y = ny,
                color = {
                    v.color[1],
                    v.color[2],
                    v.color[3],
                    0
                },
            })
    end
end
]=]

function Screen:update(dt)
    for r = 0, self.rows - 1 do
        for c = 0, self.columns - 1 do
            self._grid[r][c].hover = false
        end
    end
end

function Screen:isComplete()
    for r = 0, self.rows - 1 do
        for c = 0, self.columns - 1 do
            if not self._grid[r][c].filled then
                return false
            end
        end
    end

    return true, self.repeats
end

function Screen:getPlankCoordinates(plank)
    local x, y = plank:getPosition():unpack()
    local ox, oy = plank:getRotationOffset()

    local pc = math.floor((x + ox) / self.size)
    local pr = math.floor((y + oy) / self.size)

    return pr, pc
end

function Screen:applyPlank(plank)
    local pr, pc = self:getPlankCoordinates(plank)

    for r = 0, plank.rows - 1 do
        for c = 0, plank.columns - 1 do
            if plank.grid[r][c] then
                local nr, nc = plank:transformCoordinates(r, c)

                if pr + nr < self.rows and 
                   pr + nr >= 0 then
                    local tile = self._grid[pr + nr][pc + nc]
                    if tile then
                        if tile.filled then
                            self.repeats = self.repeats + 1
                            tile.color = { 0, 0, 255, 255 }
                        else
                            tile.filled = true
                            tile.color = { 255, 255, 255, 255 }
                        end
                    end
                end
            end
        end
    end
end

function Screen:hover(plank)
    local pr, pc = self:getPlankCoordinates(plank)

    for r = 0, plank.rows - 1 do
        for c = 0, plank.columns - 1 do
            local nr, nc = plank:transformCoordinates(r, c)
            if pr + nr < self.rows and 
               pr + nr >= 0 then
                local tile = self._grid[pr + nr][pc + nc]
                if tile then
                    tile.hover = plank.grid[r][c]
                end
            end
        end
    end
end

function Screen:draw()
    for r = 0, self.rows - 1 do
        for c = 0, self.columns - 1 do
            local tile = self._grid[r][c]

            if tile.hover then
                lg.setColor(100, 100, 100)
            else
                lg.setColor(tile.color)
            end
            lg.rectangle(
                'fill',
                tile.x + 1,
                tile.y + 1,
                tile.w - 2,
                tile.h - 2)
        end
    end

    --[=[
    for _,v in ipairs(self._fakes) do
        lg.setColor(v.color)
        lg.rectangle(
            'fill',
            v.x + 1,
            v.y + 1,
            v.w - 2,
            v.h - 2)
    end
    ]=]
end

return Screen
