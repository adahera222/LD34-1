local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

--[[
####

###
#

##
##

 ##
##

###
 #
]]

local function convert(ps)
    local grid = {}

    local r, c = 0, 0

    for line in ps:gmatch'[^\n]+' do
        c = 0

        grid[r] = {}

        for ch in line:gmatch'%d' do
            grid[r][c] = tonumber(ch) == 1

            c = c + 1
        end

        r = r + 1
    end

    return grid
end

local function createCanvas(grid, size)
    local canvas = lg.newCanvas(size * 4, size * 2)

    canvas:renderTo(function ()
        lg.setColor(255, 0, 0)

        for r = 0, 1 do
            for c = 0, 3 do
                if grid[r][c] then
                    lg.rectangle(
                        'fill',
                        c * size,
                        r * size,
                        size,
                        size)
                end
            end
        end
    end)

    return canvas
end

local Plank = Class{}
function Plank:init(x, y, size, ps)
    self.position = Vector(x, y)
    self.size = size
    self.grid = convert(ps)
    self.canvas = createCanvas(self.grid, size)
    self.rotation = 0
end

function Plank:draw()
    lg.draw(
        self.canvas,
        self.position.x,
        self.position.y,
        self.rotation,
        1,
        1,
        self.canvas:getWidth() / 2,
        self.canvas:getHeight() / 2)
end

function Plank:rotateCoordinates(r, c)
    if self.rotation == 0 then
        return r, c
    elseif self.rotation == math.pi / 2 then
        return c, 1 - r
    elseif self.rotation == math.pi then
        return 1 - r, 3 - c
    elseif self.rotation == 3 * math.pi / 2 then
        return 3 - c, r
    end
end

function Plank:getDimensions()
    if self.rotation == 0 or self.rotation == math.pi then
        return self.canvas:getWidth(), self.canvas:getHeight()
    elseif self.rotation == math.pi / 2 or self.rotation == 3 * math.pi / 2 then
        return self.canvas:getHeight(), self.canvas:getWidth()
    end
end

function Plank:keypressed(key, code)
    if key == 'left' then
        self.rotation = self.rotation + (math.pi / 2)
    elseif key == 'right' then
        self.rotation = self.rotation - (math.pi / 2)
    elseif key == 'up' or key == 'down' then
        self.rotation = self.rotation + math.pi
    end

    if self.rotation >= math.pi * 2 then
        self.rotation = self.rotation - math.pi * 2
    elseif self.rotation < 0 then
        self.rotation = self.rotation + math.pi * 2
    end
end

return Plank
