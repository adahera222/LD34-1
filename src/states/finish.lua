local lg = love.graphics

local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'
local Tween = require 'lib.tween.tween'

local AnimatedBackground = require 'src.aesthetics.animbackground'

local Finish = {}

function Finish:init()
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
end

function Finish:enter(previous, repeats, time)
    print('Entering Finish...')

    self.repeatsText =
        string.format('%d repeats', repeats)
    self.timeText =
        string.format('%.3f s', time)

    self.abg = AnimatedBackground(
        20,
        20,
        20,
        self.ms)

    self.abg.start = function (self)
        for c = 0, self.columns - 1 do
            local oy = self._grid[2][c].y

            Tween(
                2,
                self._grid[2][c],
                { y = oy - self.size })
        end

        for c = 0, self.columns - 1 do
            local oy = self._grid[3][c].y

            Tween(
                2,
                self._grid[3][c],
                { y = oy + self.size })
        end
    end

    self.color = { 255, 255, 255, 255 }
    self.textColor = { 255, 255, 255, 0 }

    self.abg:start()

    Tween(2, self.textColor, { 255, 255, 255, 255 })
    Timer.add(5, function ()
        Tween(2, self.color, { 255, 255, 255, 0 }, 'linear', Gamestate.switch, Title)
    end)
end

function Finish:leave()
    print('Leaving Finish...')
end

function Finish:draw()
    lg.setColor(self.color)
    self.abg:draw()

    lg.setColor(self.textColor)
    lg.printf(
        self.timeText,
        40,
        40,
        80,
        'center')
    lg.printf(
        self.repeatsText,
        280,
        40,
        80,
        'center')
end

return Finish
