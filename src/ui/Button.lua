local Button = {}
Button.__index = Button

function Button.new(image, imageHover, callback)
    local self = setmetatable({}, Button)
    self.image = image
    self.imageHover = imageHover
    self.callback = callback
    
    -- Pre-calcular valores que no cambian
    self.scale = 250 / image:getWidth()
    self.width = image:getWidth() * self.scale
    self.height = image:getHeight() * self.scale
    
    return self
end

function Button:draw(i)
    -- Calcular posición solo cuando sea necesario
    local x = (love.graphics.getWidth() - self.width) / 2
    local y = 230 + (i - 1) * (self.height + 50)
    
    -- Actualizar bounds para mouse detection
    self.x = x
    self.y = y
    
    -- Check hover solo una vez
    local mx, my = love.mouse.getPosition()
    local hovered = mx > x and mx < x + self.width and my > y and my < y + self.height
    
    local image = hovered and self.imageHover or self.image
    love.graphics.draw(image, x, y, 0, self.scale, self.scale)
end

function Button:isClicked(mx, my)
    return self.x and self.y and 
           mx > self.x and mx < self.x + self.width and 
           my > self.y and my < self.y + self.height
end

return Button