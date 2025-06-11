local Bird = require("src.entities.Bird")
local Pipe = require("src.entities.Pipe")
local Assets = require("src.core.Assets")
local GameState = require("src.states.GameState")

local PlayState = {}
PlayState.__index = PlayState

function PlayState.new()
    local self = setmetatable({}, PlayState)
    self.assets = Assets.new()
    self.bird = Bird.new()
    self.pipes = {}
    self.pipeTimer = 0
    self.pipeSpawnInterval = 2
    self.floorHeight = 80
    return self
end

function PlayState:update(dt)
    self.assets.ui.background.bgScroll = (self.assets.ui.background.bgScroll +
        self.assets.ui.background.bgSpeed * dt) % self.assets.ui.background.scale.bgScaledWidth

    self.assets.ui.floor.flScroll = (self.assets.ui.floor.flScroll +
        self.assets.ui.floor.flSpeed * dt) % self.assets.ui.floor.scale.flScaledWidth

    self.bird:update(dt)

    self.pipeTimer = self.pipeTimer + dt
    if self.pipeTimer > self.pipeSpawnInterval then
        table.insert(self.pipes, Pipe.new())
        self.pipeTimer = 0
    end

    for i = #self.pipes, 1, -1 do
        local pipe = self.pipes[i]
        pipe:update(dt)

        if pipe:isOffScreen() then
            table.remove(self.pipes, i)
        elseif pipe:collidesWith(self.bird) then
            GameState.set("gameover")
            return
        end
    end

    if self.bird.y + self.bird.height >= love.graphics.getHeight() - self.floorHeight then
        GameState.set("gameover")
    end
end

function PlayState:draw()
    love.graphics.setColor(1, 1, 1)

    self:drawScrollingBackground()

    self:drawScrollingFloor()

    self.bird:draw()

    for _, pipe in ipairs(self.pipes) do
        pipe:draw()
    end
end

function PlayState:drawScrollingBackground()
    love.graphics.draw(self.assets.ui.background.image,
        -self.assets.ui.background.bgScroll, 0, 0,
        self.assets.ui.background.scale.bgScale,
        self.assets.ui.background.scale.bgScale)

    love.graphics.draw(self.assets.ui.background.image,
        -self.assets.ui.background.bgScroll + self.assets.ui.background.scale.bgScaledWidth, 0, 0,
        self.assets.ui.background.scale.bgScale,
        self.assets.ui.background.scale.bgScale)
end

function PlayState:drawScrollingFloor()
    love.graphics.draw(self.assets.ui.floor.image,
        -self.assets.ui.floor.flScroll, 0, 0,
        self.assets.ui.floor.scale.flScale,
        self.assets.ui.floor.scale.flScale)

    love.graphics.draw(self.assets.ui.floor.image,
        -self.assets.ui.floor.flScroll + self.assets.ui.floor.scale.flScaledWidth, 0, 0,
        self.assets.ui.floor.scale.flScale,
        self.assets.ui.floor.scale.flScale)
end

function PlayState:keypressed(key)
    if key == "space" then
        self.bird:flap()
    end
end

function PlayState:mousepressed(_, _, button)
    if button == 1 then
        self.bird:flap()
    end
end

function PlayState:reset()
    self.bird = Bird.new()
    self.pipes = {}
    self.pipeTimer = 0
end

return PlayState
