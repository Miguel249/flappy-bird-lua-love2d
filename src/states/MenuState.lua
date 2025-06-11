local Assets = require("src.core.Assets")

local MenuState = {}
MenuState.__index = MenuState

function MenuState.new(buttons)
    local self = setmetatable({}, MenuState)
    self.assets = Assets.getInstance()
    self.buttons = buttons
    return self
end

function MenuState:update(dt)
    -- Aquí podrías agregar animaciones del menú si las necesitas
    -- Por ejemplo, efectos de hover, transiciones, etc.
end

function MenuState:draw()
    love.graphics.clear(0.2, 0.6, 0.9)

    self:drawLogo()

    self:drawButtons()
end

function MenuState:drawLogo()
    if self.assets.ui.logo then
        local logoScale = 250 / self.assets.ui.logo:getWidth()
        local logoX = (love.graphics.getWidth() - self.assets.ui.logo:getWidth() * logoScale) / 2
        local logoY = 40
        love.graphics.draw(self.assets.ui.logo, logoX, logoY, 0, logoScale, logoScale)
    end
end

function MenuState:drawButtons()
    for i, btn in ipairs(self.buttons) do
        btn:draw(i)
    end
end

function MenuState:keypressed(key)
    -- Manejo de teclas específico del menú se puede mover aquí si es necesario
end

function MenuState:mousepressed(x, y, button)
    -- Manejo de mouse específico del menú se puede mover aquí si es necesario
end

return MenuState
