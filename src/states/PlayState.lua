local Skull = require("src.entities.Skull")
local Pipe = require("src.entities.Pipe")
local Assets = require("src.core.Assets")
local GameState = require("src.states.GameState")

local PlayState = {}
PlayState.__index = PlayState

function PlayState.new()
    local self = setmetatable({}, PlayState)
    self.assets = Assets.getInstance()
    self.skull = Skull.new()
    self.pipes = {}
    self.pipeTimer = 0
    self.pipeSpawnInterval = 2
    self.floorHeight = 80
    self.points = 0
    return self
end

function PlayState:update(dt)
    self.assets.ui.background.bgScroll = (self.assets.ui.background.bgScroll +
        self.assets.ui.background.bgSpeed * dt) % self.assets.ui.background.scale.bgScaledWidth

    self.assets.ui.floor.flScroll = (self.assets.ui.floor.flScroll +
        self.assets.ui.floor.flSpeed * dt) % self.assets.ui.floor.scale.flScaledWidth

    self.skull:update(dt)

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
        elseif pipe:collidesWith(self.skull) then
            self.points = 0
            GameState.set("gameover")
            return
        end

        if pipe:givePoint() then
            self.points = self.points + 1
        end
    end

    if self.skull.y + self.skull.height >= love.graphics.getHeight() - self.floorHeight then
        self.points = 0
        GameState.set("gameover")
    end
end

function PlayState:draw()
    love.graphics.setColor(1, 1, 1)

    self:drawScrollingBackground()

    self:drawScrollingFloor()

    self.skull:draw()

    for _, pipe in ipairs(self.pipes) do
        pipe:draw()
    end

    if not GameState.is("gameover") then
        self:drawPoints()
    end
end

function PlayState:drawPoints()
    local screenWidth = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local text = tostring(self.points)
    local textWidth = font:getWidth(text)
    local x = (screenWidth - textWidth) / 2
    local y = 20 -- Margen desde el tope

    love.graphics.print(text, x, y)
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
        self.skull:flap()
    end
end

function PlayState:mousepressed(_, _, button)
    if button == 1 then
        self.skull:flap()
    end
end

function PlayState:reset()
    self.skull = Skull.new()
    self.pipes = {}
    self.pipeTimer = 0
end

return PlayState
