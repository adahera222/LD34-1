local lg = love.graphics

local Gamestate = require 'lib.hump.gamestate'
local Timer = require 'lib.hump.timer'
local Tween = require 'lib.tween.tween'

local AnimatedBackground = require 'src.aesthetics.animbackground'
local Button = require 'src.aesthetics.button'
local Play = require 'src.states.play'

local Title = {}

function Title:init()
    local ms =
        [[11111111111111111111
          11111111111111111111
          11100001100101110111
          11101110011001110111
          11100001011100000111
          11101111011001110111
          11101111100101110111
          11111111111111111111
          11111111111111111111
          11111100000000111111
          11111100000000111111
          11111111111111111111
          11111100000000111111
          11111100000000111111
          11111111111111111111
          11111100000000111111
          11111100000000111111
          11111111111111111111
          11111111111111111111
          11111111111111111111]]

    self.abg = AnimatedBackground(
        math.ceil(lg.getHeight() / 20),
        math.ceil(lg.getWidth() / 20),
        20,
        ms)

    self.fbg = AnimatedBackground(
        math.ceil(lg.getHeight() / 20),
        math.ceil(lg.getWidth() / 20),
        20,
        ms)

    self.fbg.start = function (self)
        for r = 0, self.rows - 1 do
            for c = 0, self.columns - 1 do
                self._grid[r][c] = {
                    x = self._grid[r][c].x + self._grid[r][c].w / 2 - 1,
                    y = self._grid[r][c].y + self._grid[r][c].h / 2 - 1,
                    w = 2,
                    h = 2,
                    filled = self._grid[r][c].filled
                }
                if r == self.rows - 1 and c == self.columns - 1 then
                    Tween(
                        1,
                        self._grid[r][c],
                        {
                            x = c * self.size,
                            y = r * self.size,
                            w = self.size,
                            h = self.size,
                        },
                        'inQuad',
                        Gamestate.switch,
                        Play)
                end
                Tween(
                    1,
                    self._grid[r][c],
                    {
                        x = c * self.size,
                        y = r * self.size,
                        w = self.size,
                        h = self.size,
                    },
                    'inQuad')
            end
        end
    end

    self.fbg.draw = function (self)
        for r = 0, self.rows - 1 do
            for c = 0, self.columns - 1 do
                local rect = self._grid[r][c]

                if not rect.filled then
                    lg.setColor(255, 255, 255)
                    lg.rectangle(
                        'fill',
                        rect.x + 1,
                        rect.y + 1,
                        rect.w - 2,
                        rect.h - 2)
                end

            end
        end
    end

    self.fbgflag = false

    self.buttons = {
        Button(120, 180, 160, 40, 'Play', lg.getFont()),
        Button(120, 240, 160, 40, 'Tutorial', lg.getFont()),
        Button(120, 300, 160, 40, 'Quit', lg.getFont()),
    }

    self.buttons[1]:setCallback(function()
        self.fbg:start()
        self.fbgflag = true
    end)
    self.buttons[2]:setCallback(function () print('No tutorial state yet') end)
    self.buttons[3]:setCallback(function ()
        love.event.quit()
    end)
end

function Title:enter(previous, ...)
    self.abg:start()

    for _,button in ipairs(self.buttons) do
        button.colors.font[4] = 0
        Timer.add(5.5, function ()
            Tween(
                3,
                button.colors.font,
                {
                    button.colors.font[1],
                    button.colors.font[2],
                    button.colors.font[3],
                    255
                })
        end)
    end
end

function Title:leave()
end

function Title:update(dt)
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Title:draw()
    self.abg:draw()


    if self.fbgflag then
        self.fbg:draw()
    else
        for _,button in ipairs(self.buttons) do
            button:draw()
        end
    end
end

function Title:focus()
end

function Title:keypressed(key, code)
end

function Title:keyreleased(key, code)
end

function Title:mousepressed(x, y, button)
end

function Title:mousereleased(x, y, button)
end

function Title:quit()
end

return Title
