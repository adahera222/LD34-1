local lg = love.graphics

local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'
local Tween = require 'lib.tween.tween'

local AnimatedBackground = require 'src.aesthetics.animbackground'
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

    self.ms = 
      [[11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111
        11111111111111111111]]

    self.plate = {
        x = 140,
        y = 100,
        w = 120,
        h = 200,
    }
end

function Choose:enter(previous, ...)
    print('Entering Choose...')

    self.previous = previous
    self.selected = -1

    self.abg = AnimatedBackground(
        20,
        20,
        20,
        self.ms)

    self.abg.start = function (self)
        print('First start')
        for r = 0, self.rows - 1 do
            for c = 0, self.columns - 1 do
                local tile = self._grid[r][c]
                local ox = 0

                if c < 10 then
                    ox = -self.size
                else
                    ox = lg.getWidth()
                end

                if c == 6 or c == (self.columns - 1) - 6 then
                    Tween(
                        3,
                        tile,
                        { x = ox },
                        'inCubic')
                elseif c == 7 or c == (self.columns - 1) - 7 then
                    Tween(
                        3.25,
                        tile,
                        { x = ox },
                        'inCubic')
                elseif c == 8 or c == (self.columns - 1) - 8 then
                    Tween(
                        3.5,
                        tile,
                        { x = ox },
                        'inCubic')
                elseif c == 9 or c == (self.columns - 1) - 9 then
                    Tween(
                        3.75,
                        tile,
                        { x = ox },
                        'inCubic')
                end
            end
        end
    end
    self.abg:start()

    self.chosen = {}

    for i,v in ipairs(self.ts) do
        self.chosen[i] = v
    end

    table.remove(self.chosen, math.random(#self.chosen))
    table.remove(self.chosen, math.random(#self.chosen))

    for i,v in ipairs(self.chosen) do
        print(i, v)
    end

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

    for i,t in ipairs(self.tetrominos) do
        t.color[4] = 0
        Timer.add(2,
            function ()
                Tween(
                    1.75,
                    t.color,
                    { 255, 255, 255, 255 },
                    'linear',
                    print,
                    'FINISHED: ' .. i)
            end)
    end

    print(#self.tetrominos)
end

function Choose:leave()
    print('Leaving Choose...')

    self.previous:setPlank(self.tetrominos[self.selected].ps)

    self.abg = nil
    self.tetrominos = nil
    self.chosen = nil

    self.previous:startAnimation()
end

function Choose:draw()
    self.abg:draw()

    for i,tetromino in ipairs(self.tetrominos) do
        tetromino:draw()
    end
end

function Choose:mousepressed(x, y, button)
    for i, tetromino in ipairs(self.tetrominos) do
        local px, py, pw, ph = tetromino:getBoundingBox()

        if px <= x and x <= px + pw and
           py <= y and y <= py + ph then
            self.selected = i

            self.abg.start = function (self)
                print('Second start')
                for r = 0, self.rows - 1 do
                    for c = 0, self.columns - 1 do
                        local tile = self._grid[r][c]
                        local ox = c * self.size

                        if c == 6 or c == (self.columns - 1) - 6 then
                            Tween(
                                3,
                                tile,
                                { x = ox },
                                'outCubic')
                        elseif c == 7 or c == (self.columns - 1) - 7 then
                            Tween(
                                3.25,
                                tile,
                                { x = ox },
                                'outCubic')
                        elseif c == 8 or c == (self.columns - 1) - 8 then
                            Tween(
                                3.5,
                                tile,
                                { x = ox },
                                'outCubic')
                        elseif c == 9 or c == (self.columns - 1) - 9 then
                            Tween(
                                3.75,
                                tile,
                                { x = ox },
                                'outCubic')
                        end
                    end
                end
            end

            self.abg:start()
            self.abgflag = true

            for _,t in ipairs(self.tetrominos) do
                Tween(1, t.color, { 255, 255, 255, 0 })
            end

            Timer.add(4, Gamestate.pop)
            break
        end
    end
end

return Choose
