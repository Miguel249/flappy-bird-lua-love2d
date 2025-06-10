local Button = {}
Button.__index = Button

function Button.new(image, imageHover, callback)
    local self = setmetatable({}, Button)
    self.image = image
    self.imageHover = imageHover
    self.callback = callback
    return self
end

function Button:draw(i)
    local mx, my = love.mouse.getPosition()
    local scale = 250 / self.image:getWidth()
    local bw = self.image:getWidth() * scale
    local bh = self.image:getHeight() * scale
    local x = (love.graphics.getWidth() - bw) / 2
    local y = 230 + (i - 1) * (bh + 50)

    self.width = bw
    self.height = bh
    self.x = x
    self.y = y

    local hovered = mx > x and mx < x + bw and my > y and my < y + bh
    local image = hovered and self.imageHover or self.image
    love.graphics.draw(image, x, y, 0, scale, scale)
end

return Button
