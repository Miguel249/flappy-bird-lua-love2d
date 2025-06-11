local Assets = require "src.core.Assets"
local Pipe = {}
Pipe.__index = Pipe

local sharedAssets = nil

function Pipe.new()
    local self = setmetatable({}, Pipe)

    if not sharedAssets then
        sharedAssets = Assets.getInstance()
    end
    self.assets = sharedAssets

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
    if not self.assets.ui.infernalPipe or not self.assets.pipeQuads then return end

    local texture = self.assets.ui.infernalPipe
    local texWidth = texture:getWidth()
    local texHeight = texture:getHeight()

    local borderQuad = self.assets.pipeQuads.border
    local repeatableQuad = self.assets.pipeQuads.repeatable

    local scale = width / texWidth

    local borderHeight = math.floor(texHeight / 4.3)
    local repeatableHeight = texHeight - borderHeight
    local scaledBorderHeight = borderHeight * scale
    local scaledRepeatableHeight = repeatableHeight * scale

    if not flipVertical then
        local currentY = y
        local heightForRepeating = height - scaledBorderHeight

        love.graphics.draw(texture, borderQuad, x, currentY + scaledBorderHeight, 0, scale,
            -scaledBorderHeight / borderHeight)

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

        while heightForRepeating > 0 and currentY < y + height - scaledBorderHeight do
            local drawHeight = math.min(heightForRepeating, scaledRepeatableHeight)
            local quadScale = drawHeight / repeatableHeight
            love.graphics.draw(texture, repeatableQuad, x, currentY, 0, scale, quadScale)

            currentY = currentY + drawHeight
            heightForRepeating = heightForRepeating - drawHeight
        end

        love.graphics.draw(texture, borderQuad, x, y + height - scaledBorderHeight, 0, scale,
            scaledBorderHeight / borderHeight)
    end
end

function Pipe:draw()
    if self.gapY > 0 then
        self:drawTexturedSection(self.x, 0, self.width, self.gapY, true)
    end

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
