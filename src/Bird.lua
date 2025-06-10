local Bird = {}
Bird.__index = Bird

function Bird.new()
    local self = setmetatable({}, Bird)
    self.x = 100
    self.y = 300
    self.width = 30
    self.height = 30
    self.velocity = 0
    self.gravity = 800
    self.lift = -300
    return self
end

function Bird:update(dt)
    self.velocity = self.velocity + self.gravity * dt
    self.y = self.y + self.velocity * dt

    if self.y < 0 then
        self.y = 0
        self.velocity = 0
    end

    if self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
        self.velocity = 0
    end
end

function Bird:flap()
    self.velocity = self.lift
end

function Bird:draw()
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Bird:getBounds()
    return self.x, self.y, self.width, self.height
end

return Bird
