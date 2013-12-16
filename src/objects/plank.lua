local lg = love.graphics

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector'

local Tetromino = require 'src.aesthetics.tetromino'

local Plank = Class{}
function Plank:init(x, y, size, ps)
    self.tetromino = Tetromino(x, y, size, size, ps)
    self.rows = 2
    self.columns = 4
    self.rotation = 0
    self.flipped = false
    self.size = size

    self.grid = {}

    local r = 0
    for line in ps:gmatch'[^\n]+' do
        local c = 0
        self.grid[r] = {}
        for ch in line:gmatch'%d' do
            self.grid[r][c] = tonumber(ch) == 1
            c = c + 1
        end
        r = r + 1
    end
end

function Plank:getPosition()
    return self.tetromino.position
end

function Plank:setPosition(x, y)
    self.tetromino.position = Vector(x, y)
end

function Plank:transformCoordinates(r, c)
    if self.flipped then
        r = (self.rows - 1) - r
    end

    if     self.rotation == 0 then
        return r, c
    elseif self.rotation == math.pi / 2 then
        return c, (self.rows - 1) - r
    elseif self.rotation == math.pi then
        return (self.rows - 1) - r, (self.columns - 1) - c
    elseif self.rotation == 3 * math.pi / 2 then
        return (self.columns - 1) - c, r
    end
end

function Plank:rotate(r)
    self.rotation = self.rotation + r

    if self.rotation >= 2 * math.pi then
        self.rotation = self.rotation - 2 * math.pi
    elseif self.rotation < 0 then
        self.rotation = self.rotation + 2 * math.pi
    end
end

function Plank:getRotationOffset()
    local ox, oy = 0, 0

    if self.rotation == 0 then
        if self.flipped then
            oy = oy - self.size
        end
    elseif self.rotation == math.pi / 2 then
        if self.flipped then
            ox = ox + self.size
        end

        ox = ox + (self.size - self.tetromino.canvas:getHeight())
    elseif self.rotation == math.pi then
        if self.flipped then
            oy = oy + self.size
        end

        ox = ox + (self.size - self.tetromino.canvas:getWidth())
        oy = oy + (self.size - self.tetromino.canvas:getHeight())
    elseif self.rotation == 3 * math.pi / 2 then
        if self.flipped then
            ox = ox - self.size
        end

        oy = oy + self.size - self.tetromino.canvas:getWidth()
    end

    return ox, oy
end

function Plank:draw()
    lg.setColor(255, 0, 0)
    lg.draw(
        self.tetromino.canvas,
        self.tetromino.position.x,
        self.tetromino.position.y,
        self.rotation,
        1,
        self.flipped and -1 or 1)
end

function Plank:keypressed(key, code)
    if key == 'left' then
        self:rotate(math.pi / 2)
    elseif key == 'right' then
        self:rotate(-math.pi / 2)
    elseif key == 'up' or key == 'down' then
        self.flipped = not self.flipped
    end
end

return Plank
