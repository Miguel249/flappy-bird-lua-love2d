local Pipe = {}
Pipe.__index = Pipe

function Pipe.new()
    local self = setmetatable({}, Pipe)
    self.width = 50
    self.gapHeight = 150
    self.speed = 100
    self.x = love.graphics.getWidth()

    local screenHeight = love.graphics.getHeight()
    local floorHeight = 80
    self.gapY = math.random(100, screenHeight - self.gapHeight - floorHeight)

    return self
end

function Pipe:update(dt)
    self.x = self.x - self.speed * dt
end

function Pipe:draw()
    love.graphics.setColor(love.math.colorFromBytes(127, 51, 43))

    love.graphics.rectangle("fill", self.x, 0, self.width, self.gapY)

    love.graphics.rectangle("fill", self.x, self.gapY + self.gapHeight, self.width,
        love.graphics.getHeight() - self.gapY - self.gapHeight - 80)
end

function Pipe:isOffScreen()
    return self.x + self.width < 0
end

function Pipe:collidesWith(bird)
    local bx, by, bw, bh = bird:getBounds()
    if bx < self.x + self.width and bx + bw > self.x then
        if by < self.gapY or by + bh > self.gapY + self.gapHeight then
            return true
        end
    end
    return false
end

return Pipe
