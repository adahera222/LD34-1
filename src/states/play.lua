local lf = love.filesystem
local lg = love.graphics
local lm = love.mouse

local Gamestate = require 'lib.hump.gamestate'

local Plank = require 'src.objects.plank'
local Screen = require 'src.objects.screen'

local Choose = require 'src.states.choose'

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

    self.testms = lf.read(dir .. 'test.txt')
end

function Play:enter(previous, cl)
    print('Entering Play...')

    self.currentLevel = cl or 1

    Gamestate.push(Choose)

    self.screen = Screen(20, 20, 20, self.testms)
end

function Play:leave()
    print('Leaving Play...')

    self.screen = nil
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
        end
    end
end

function Play:draw()
    print('Play.draw')

    self.screen:draw()
end

function Play:keypressed(key, code)
    self.plank:keypressed(key, code)

    if key == ' ' then
        Gamestate.switch(Play)
    end
end

function Play:mousereleased(x, y, button)
    self.screen:applyPlank(self.plank)
end

function Play:setPlank(ps)
    self.plank = Plank(
        lm.getX(),
        lm.getY(),
        20,
        ps)
end

function Play:startAnimation()
    self.screen:start()
end

return Play
