local Assets = require "src.core.Assets"
local Pipe = {}
Pipe.__index = Pipe

function Pipe.new()
    local self = setmetatable({}, Pipe)
    self.assets = Assets.new()
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

function Pipe:drawTexturedSection(x, y, width, height, flipVertical)
    if not self.assets.ui.infernalPipe then return end

    local texture = self.assets.ui.infernalPipe
    local texWidth = texture:getWidth()
    local texHeight = texture:getHeight()

    -- Escala para mantener proporciones (solo escalamos para ajustar al ancho)
    local scale = width / texWidth
    local scaledTexHeight = texHeight * scale

    -- El borde inferior ocupa aproximadamente 1/4.3 de la textura
    local borderHeight = math.floor(texHeight / 4.3)
    local repeatableHeight = texHeight - borderHeight
    local scaledBorderHeight = borderHeight * scale
    local scaledRepeatableHeight = repeatableHeight * scale

    if not flipVertical then
        -- Para el pipe superior (invertido)
        local currentY = y

        -- Reservamos espacio para el borde al final (que al estar invertido queda arriba)
        local heightForRepeating = height - scaledBorderHeight

        -- Primero dibujamos el borde (invertido, queda arriba)
        local borderQuad = love.graphics.newQuad(0, repeatableHeight, texWidth, borderHeight, texWidth, texHeight)
        love.graphics.draw(texture, borderQuad, x, currentY + scaledBorderHeight, 0, scale,
            -scaledBorderHeight / borderHeight)

        -- Luego repetimos la parte repetible desde abajo hacia arriba
        currentY = currentY + scaledBorderHeight
        while heightForRepeating > 0 do
            local drawHeight = math.min(heightForRepeating, scaledRepeatableHeight)

            -- Solo la parte repetible (sin el borde)
            local quad = love.graphics.newQuad(0, 0, texWidth, repeatableHeight, texWidth, texHeight)
            local quadScale = drawHeight / repeatableHeight
            love.graphics.draw(texture, quad, x, currentY + drawHeight, 0, scale, -quadScale)

            currentY = currentY + drawHeight
            heightForRepeating = heightForRepeating - drawHeight
        end
    else
        -- Para el pipe inferior (normal)
        local currentY = y

        -- Reservamos espacio para el borde al final
        local heightForRepeating = height - scaledBorderHeight

        -- Repetimos la parte superior de la textura (sin el borde)
        while heightForRepeating > 0 and currentY < y + height - scaledBorderHeight do
            local drawHeight = math.min(heightForRepeating, scaledRepeatableHeight)

            -- Solo la parte repetible (sin el borde inferior)
            local quad = love.graphics.newQuad(0, 0, texWidth, repeatableHeight, texWidth, texHeight)
            local quadScale = drawHeight / repeatableHeight
            love.graphics.draw(texture, quad, x, currentY, 0, scale, quadScale)

            currentY = currentY + drawHeight
            heightForRepeating = heightForRepeating - drawHeight
        end

        -- Dibujamos el borde al final
        local borderQuad = love.graphics.newQuad(0, repeatableHeight, texWidth, borderHeight, texWidth, texHeight)
        love.graphics.draw(texture, borderQuad, x, y + height - scaledBorderHeight, 0, scale,
            scaledBorderHeight / borderHeight)
    end
end

function Pipe:draw()
    -- Pipe superior (invertido)
    if self.gapY > 0 then
        self:drawTexturedSection(self.x, 0, self.width, self.gapY, true)
    end

    -- Pipe inferior
    local bottomHeight = love.graphics.getHeight() - self.gapY - self.gapHeight - 80
    if bottomHeight > 0 then
        self:drawTexturedSection(self.x, self.gapY + self.gapHeight, self.width, bottomHeight, false)
    end
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
