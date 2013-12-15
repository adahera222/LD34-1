local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'
local Tween = require 'lib.tween.tween'

local function convert(ms, size)
    local r, c = 0, 0
    local tiles = {}

    for line in ms:gmatch'[^\n]+' do
        c = 0
        for ch in line:gmatch'%d' do
            if tonumber(ch) == 0 then
                table.insert(tiles, {
                    x = c * size,
                    y = r * size,
                    w = size,
                    h = size,
                    color = { 255, 255, 255 },
                })
            end
            c = c + 1
        end
        r = r + 1
    end

    return tiles, r, c
end

local AnimatedScreen = Class{}
function AnimatedScreen:init(ms, size, x, y)
    local tiles, rows, columns = convert(ms, size)

    self.position = Vector(x, y)
    self.rows = rows
    self.columns = columns
    self.tiles = tiles
end

function AnimatedScreen:start()
    for _,tile in ipairs(self.tiles) do
        local ty = tile.y
        Tween(
            3,
            tile,
            { y = lg.getHeight() + ty, color = { 0, 0, 0 } },
            'inQuad')
    end
end

function AnimatedScreen:draw()
    for _,tile in ipairs(self.tiles) do
        lg.setColor(tile.color)
        lg.rectangle(
            'fill',
            self.position.x + tile.x - 1,
            self.position.y + tile.y - 1,
            tile.w - 2,
            tile.h - 2)
    end
end

return AnimatedScreen
