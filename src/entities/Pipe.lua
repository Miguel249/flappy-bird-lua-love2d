local Assets = require "src.core.Assets"
local Shaders = require "src.core.Shaders"
local Pipe = {}
Pipe.__index = Pipe

local sharedAssets = nil
local sharedShaders = nil

function Pipe.new()
    local self = setmetatable({}, Pipe)

    if not sharedAssets then
        sharedAssets = Assets.getInstance()
    end
    self.assets = sharedAssets

    if not sharedShaders then
        sharedShaders = Shaders.getInstance()
    end
    self.shaders = sharedShaders

    self.width = 50
    self.gapHeight = 150
    self.speed = 100
    self.x = love.graphics.getWidth()

    local screenHeight = love.graphics.getHeight()
    local floorHeight = 80
    self.gapY = math.random(100, screenHeight - self.gapHeight - floorHeight)

    -- Crear canvas para efectos de blur
    self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
    self.blurCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

    self.scored = false

    return self
end

function Pipe:update(dt)
    self.x = self.x - self.speed * dt
end

function Pipe:drawTexturedSection(x, y, width, height, flipVertical)
    if not self.assets.ui.infernalPipe or not self.assets.pipeQuads then return end

    local texture = self.assets.ui.infernalPipe
    local texWidth = texture:getWidth()
    local texHeight = texture:getHeight()

    local borderQuad = self.assets.pipeQuads.border
    local repeatableQuad = self.assets.pipeQuads.repeatable

    local scale = width / texWidth

    local borderHeight = math.floor(texHeight / 3)
    local repeatableHeight = texHeight - borderHeight
    local scaledBorderHeight = borderHeight * scale
    local scaledRepeatableHeight = repeatableHeight * scale

    if not flipVertical then
        local currentY = y
        local heightForRepeating = height - scaledBorderHeight

        -- Dibujar borde superior
        love.graphics.draw(texture, borderQuad, x, currentY + scaledBorderHeight, 0, scale,
            -scaledBorderHeight / borderHeight)

        -- Dibujar sección repetible
        currentY = currentY + scaledBorderHeight
        while heightForRepeating > 0 do
            local drawHeight = math.min(heightForRepeating, scaledRepeatableHeight)
            local quadScale = drawHeight / repeatableHeight
            love.graphics.draw(texture, repeatableQuad, x, currentY + drawHeight, 0, scale, -quadScale)

            currentY = currentY + drawHeight
            heightForRepeating = heightForRepeating - drawHeight
        end
    else
        local currentY = y
        local heightForRepeating = height - scaledBorderHeight

        -- Dibujar sección repetible
        while heightForRepeating > 0 and currentY < y + height - scaledBorderHeight do
            local drawHeight = math.min(heightForRepeating, scaledRepeatableHeight)
            local quadScale = drawHeight / repeatableHeight
            love.graphics.draw(texture, repeatableQuad, x, currentY, 0, scale, quadScale)

            currentY = currentY + drawHeight
            heightForRepeating = heightForRepeating - drawHeight
        end

        -- Dibujar borde inferior
        love.graphics.draw(texture, borderQuad, x, y + height - scaledBorderHeight, 0, scale,
            scaledBorderHeight / borderHeight)
    end
end

function Pipe:drawWithBlur()
    -- Primero dibujar en el canvas normal
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    if self.gapY > 0 then
        self:drawTexturedSection(self.x, 0, self.width, self.gapY, true)
    end

    local bottomHeight = love.graphics.getHeight() - self.gapY - self.gapHeight - 80
    if bottomHeight > 0 then
        self:drawTexturedSection(self.x, self.gapY + self.gapHeight, self.width, bottomHeight, false)
    end

    love.graphics.setCanvas()

    -- Aplicar blur si el shader está disponible
    if self.shaders and self.shaders.blurShader then
        love.graphics.setCanvas(self.blurCanvas)
        love.graphics.clear()
        love.graphics.setShader(self.shaders.blurShader)
        love.graphics.draw(self.canvas)
        love.graphics.setShader()
        love.graphics.setCanvas()

        -- Dibujar el resultado con blur
        love.graphics.draw(self.blurCanvas)
    else
        -- Si no hay shader de blur, dibujar normal
        love.graphics.draw(self.canvas)
    end
end

function Pipe:draw()
    self:drawWithBlur()
end

function Pipe:isOffScreen()
    return self.x + self.width < 0
end

function Pipe:givePoint()
    if not self.scored and self.x + self.width/2 < 100 then
        self.scored = true
        return true
    end
    return false
end


function Pipe:collidesWith(skull)
    local bx, by, bw, bh = skull:getBounds()
    if bx < self.x + self.width and bx + bw > self.x then
        if by < self.gapY or by + bh > self.gapY + self.gapHeight then
            return true
        end
    end
    return false
end

return Pipe
