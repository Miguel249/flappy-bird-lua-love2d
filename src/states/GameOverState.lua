-- src/states/GameOverState.lua
local Assets = require("src.core.Assets")
local GameState = require("src.states.GameState")

local GameOverState = {}
GameOverState.__index = GameOverState

function GameOverState.new(playState)
    local self = setmetatable({}, GameOverState)
    self.assets = Assets.new()
    self.playState = playState -- Referencia al estado de juego para poder dibujarlo de fondo
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

    -- Overlay semi-transparente
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Texto de game over
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.fontLarge)
    love.graphics.printf("¡Game Over!", 0, 120, love.graphics.getWidth(), "center")

    -- Instrucciones
    love.graphics.setFont(self.fontMedium)
    love.graphics.printf("[R] Reiniciar", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("[M] Menú", 0, 230, love.graphics.getWidth(), "center")
    love.graphics.printf("[ESC] Salir", 0, 260, love.graphics.getWidth(), "center")
end

function GameOverState:keypressed(key)
    if key == "r" then
        self:restartGame()
    elseif key == "m" then
        GameState.set("menu")
    elseif key == "escape" then
        love.event.quit()
    end
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