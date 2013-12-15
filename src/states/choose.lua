local lg = love.graphics

local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'

local Screen = require 'src.objects.screen'
local Tetromino = require 'src.aesthetics.tetromino'

local Choose = {}

function Choose:init()
    self.ts = {
        [[1111
          0000]],
        [[1110
          1000]],
        [[1100
          1100]],
        [[0110
          1100]],
        [[1110
          0100]],
    }

    self.plate = {
        x = lg.getWidth() / 3,
        y = lg.getHeight() / 4,
        w = lg.getWidth() / 3,
        h = lg.getHeight() / 2,
    }
end

function Choose:enter(previous, background)
    print('Entering Choose...')

    self.previous = previous
    self.background = background

    self.selected = -1
    self.chosen = {}

    for i,v in ipairs(self.ts) do
        self.chosen[i] = v
    end

    table.remove(self.chosen, math.random(#self.chosen))
    table.remove(self.chosen, math.random(#self.chosen))

    local tw = self.plate.w / 6
    local th = self.plate.h / 10
    self.tetrominos = {
        Tetromino(
            self.plate.x + tw,
            self.plate.y + th,
            tw,
            th,
            self.chosen[1]),
        Tetromino(
            self.plate.x + tw,
            self.plate.y + th * 4,
            tw,
            th,
            self.chosen[2]),
        Tetromino(
            self.plate.x + tw,
            self.plate.y + th * 7,
            tw,
            th,
            self.chosen[3]),
    }
end

function Choose:leave()
    print('Leaving Choose...')

    self.previous.as:start()

    return self.tetrominos[self.selected].ps
end

function Choose:update(dt)
end

function Choose:draw()
    self.background:draw()

    lg.setLineWidth(3)
    lg.setColor(150, 150, 150)
    lg.line(
        self.plate.x + self.plate.w, self.plate.y,
        self.plate.x + self.plate.w, self.plate.y + self.plate.h,
        self.plate.x, self.plate.y + self.plate.h)

    lg.setColor(100, 100, 100)
    lg.rectangle(
        'fill',
        self.plate.x,
        self.plate.y,
        self.plate.w,
        self.plate.h)

    if self.selected ~= -1 then
        local x, y, w, h =
            self.tetrominos[self.selected]:getBoundingBox()
        lg.setColor(200, 200, 200)
        lg.rectangle('line', x, y, w, h)
    end

    lg.setColor(255, 0, 0)
    for _, tetromino in ipairs(self.tetrominos) do
        tetromino:draw()
    end
end

function Choose:keypressed(key, code)
    if key == ' ' then
        self.previous:setPlank(Gamestate.pop())
    end
end

function Choose:mousepressed(x, y, button)
    for i, tetromino in ipairs(self.tetrominos) do
        local px, py, pw, ph = tetromino:getBoundingBox()

        if px <= x and x <= px + pw and
           py <= y and y <= py + ph then
            self.selected = i
            break
        end
    end
end

return Choose
