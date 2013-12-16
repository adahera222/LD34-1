local lf = love.filesystem
local lg = love.graphics
local lm = love.mouse

local Gamestate = require 'lib.hump.gamestate'

local Plank = require 'src.objects.plank'
local Screen = require 'src.objects.screen'

local Play = {}

function Play:init()
    self.totalRepeats = 0
    self.currentLevel = 1
    self.levels = {}

    local dir = 'assets/levels/'
    local files = lf.enumerate(dir)
    for i,file in ipairs(files) do
        local contents = lf.read(dir .. file)
        self.levels[i] = contents
    end
end

function Play:enter(previous, cl)
    print('Entering Play...')

    self.currentLevel = cl or 1

    Gamestate.push(Choose)

    self.screen = Screen(20, 20, 20, self.levels[self.currentLevel])
end

function Play:leave()
    print('Leaving Play...')

    self.screen = nil
    self.start = nil
end

function Play:update(dt)
    self.plank:setPosition(lm.getX(), lm.getY())

    self.screen:update(dt)

    self.screen:hover(self.plank)

    local b, repeats = self.screen:isComplete()
    if b then
        self.totalRepeats = self.totalRepeats + repeats

        if self.currentLevel < #self.levels then
            Gamestate.switch(Play, self.currentLevel + 1)
        else
            Gamestate.switch(Finish, self.totalRepeats, love.timer.getTime() - self.start)
        end
    end
end

function Play:draw()
    self.screen:draw()
end

function Play:keypressed(key, code)
    self.plank:keypressed(key, code)
end

function Play:mousereleased(x, y, button)
    self.screen:applyPlank(self.plank)
end

function Play:setPlank(ps)
    self.start = love.timer.getTime()

    self.plank = Plank(
        lm.getX(),
        lm.getY(),
        20,
        ps)
end

return Play
