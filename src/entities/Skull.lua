local Assets = require "src.core.Assets"
local Skull = {}
Skull.__index = Skull

function Skull.new()
    local self = setmetatable({}, Skull)
    self.assets = Assets.getInstance() -- Usar singleton
    self.x = 100
    self.y = 300
    self.width = 30
    self.height = 30
    self.velocity = 0
    self.gravity = 1200
    self.lift = -400
    return self
end

function Skull:update(dt)
    self.velocity = self.velocity + self.gravity * dt
    self.y = self.y + self.velocity * dt

    if self.y < 0 then
        self.y = 0
        self.velocity = 0
    end

    if self.y + self.height > love.graphics.getHeight() - 80 then
        self.y = love.graphics.getHeight() - self.height - 80
        self.velocity = 0
    end
end

function Skull:flap()
    self.velocity = self.lift
end

function Skull:draw()
    if self.assets.ui.skull then
        local skullScale = 30 / self.assets.ui.skull:getWidth()
        love.graphics.draw(self.assets.ui.skull, self.x, self.y, 0, skullScale, skullScale)
    end
end

function Skull:getBounds()
    return self.x, self.y, self.width, self.height
end

return Skull