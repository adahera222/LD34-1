local lg = love.graphics

local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'

local Plank = require 'src.objects.plank'
local Screen = require 'src.objects.screen'

local Choose = {}

function Choose:init()
    self.tetrominos = {
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
        x = lg.getWidth() / 2 - lg.getWidth() / 4,
        y = lg.getHeight() / 2 - lg.getHeight() / 4,
        w = lg.getWidth() / 2,
        h = lg.getWidth() / 2,
    }
end

function Choose:enter(previous, ms, background)
    print('Entering Choose...')

    self.previous = previous
    self.background = background

    self.screen = Screen(ms, 15, 200, 200)

    self.selected = -1
    self.chosen = {}

    for i,v in ipairs(self.tetrominos) do
        self.chosen[i] = v
    end

    table.remove(self.chosen, math.random(#self.chosen))
    table.remove(self.chosen, math.random(#self.chosen))

    self.planks = {}
    for i,v in ipairs(self.chosen) do
        self.planks[i] = Plank(
            self.plate.x + 65 * (i + 1) - 55,
            self.plate.y + 50,
            15,
            v)
    end
end

function Choose:leave()
    print('Leaving Choose...')

    return self.planks[self.selected].ps
end

function Choose:update(dt)
    self.background:update(dt)
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
            self.planks[self.selected]:getCanvasBox()

        lg.setColor(50, 50, 50)
        lg.rectangle('fill', x, y, w, h)
    end

    for _, plank in ipairs(self.planks) do
        plank:draw()
    end

    self.screen:draw()
end

function Choose:keypressed(key, code)
    if key == ' ' then
        self.previous:setPlank(Gamestate.pop())
    end
end

function Choose:mousepressed(x, y, button)
    for i, plank in ipairs(self.planks) do
        local px, py, pw, ph = plank:getCanvasBox()

        if px <= x and x <= px + pw and
           py <= y and y <= py + ph then
            self.selected = i
            break
        end
    end
end

function Choose:quit()
end

return Choose
