local Assets = require("src.core.Assets")
local GameState = require("src.states.GameState")

local GameOverState = {}
GameOverState.__index = GameOverState

function GameOverState.new(playState, buttons)
    local self = setmetatable({}, GameOverState)
    self.assets = Assets.getInstance()
    self.playState = playState -- Referencia al estado de juego para poder dibujarlo de fondo
    self.buttons = buttons
    self.fontLarge = love.graphics.newFont(36)
    self.fontMedium = love.graphics.newFont(22)
    return self
end

function GameOverState:update(dt)
    -- En game over no necesitamos actualizar nada especial
    -- pero podríamos agregar efectos o animaciones aquí
end

function GameOverState:draw()
    -- Dibujar el estado del juego de fondo (congelado)
    if self.playState then
        self.playState:draw()
    end

    self:drawGameOver()

    -- Instrucciones
    self:drawButtons()
end

function GameOverState:drawGameOver()
    if self.assets.ui.gameOver then
        local gameoverScale = 250 / self.assets.ui.gameOver:getWidth()
        local gameoverX = (love.graphics.getWidth() - self.assets.ui.gameOver:getWidth() * gameoverScale) / 2
        local gameoverY = 40
        love.graphics.draw(self.assets.ui.gameOver, gameoverX, gameoverY, 0, gameoverScale, gameoverScale)
    end
end

function GameOverState:drawButtons()
    for i, btn in ipairs(self.buttons) do
        btn:draw(i)
    end
end

function GameOverState:keypressed(key)
    -- Manejo de teclas específico del gameover se puede mover aquí si es necesario
end

function GameOverState:mousepressed(x, y, button)
    -- Podrías agregar botones clickeables aquí si quieres
end

function GameOverState:restartGame()
    if self.playState then
        self.playState:reset()
    end
    GameState.set("play")
end

return GameOverState
