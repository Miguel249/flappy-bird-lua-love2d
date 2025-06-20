local GameState = require("src.states.GameState")
local MenuState = require("src.states.MenuState")
local PlayState = require("src.states.PlayState")
local GameOverState = require("src.states.GameOverState")
local Button = require("src.ui.Button")
local Assets = require("src.core.Assets")

local StateManager = {}
StateManager.__index = StateManager

function StateManager.new()
    local self = setmetatable({}, StateManager)

    local assets = Assets.getInstance() -- Usar singleton

    local menuButtons = {
        Button.new(assets.ui.buttonPlay, assets.ui.buttonPlayHover, function()
            self:startGame()
        end),
        Button.new(assets.ui.buttonExit, assets.ui.buttonExitHover, function()
            love.event.quit()
        end),
    }

    local gameOverButtons = {
        Button.new(assets.ui.buttonRestart, assets.ui.buttonRestartHover, function()
            self:startGame()
        end),
        Button.new(assets.ui.buttonMenu, assets.ui.buttonMenuHover, function()
            GameState.set("menu")
        end),
        Button.new(assets.ui.buttonExit, assets.ui.buttonExitHover, function()
            love.event.quit()
        end),
    }

    self.menuState = MenuState.new(menuButtons)
    self.playState = PlayState.new()
    self.gameOverState = GameOverState.new(self.playState, gameOverButtons)

    GameState.set("menu")

    return self
end

function StateManager:update(dt)
    if GameState.is("menu") then
        self.menuState:update(dt)
    elseif GameState.is("play") then
        self.playState:update(dt)
    elseif GameState.is("gameover") then
        self.gameOverState:update(dt)
    end
end

function StateManager:draw()
    if GameState.is("menu") then
        self.menuState:draw()
    elseif GameState.is("play") then
        self.playState:draw()
    elseif GameState.is("gameover") then
        self.gameOverState:draw()
    end
end

function StateManager:keypressed(key)
    if GameState.is("menu") then
        self:handleMenuKeypress(key)
    elseif GameState.is("play") then
        self.playState:keypressed(key)
    elseif GameState.is("gameover") then
        self.gameOverState:keypressed(key)
    end
end

function StateManager:mousepressed(x, y, button)
    if button ~= 1 then return end -- Early exit si no es click izquierdo
    
    if GameState.is("menu") then
        self:handleMenuMousepress(x, y)
    elseif GameState.is("play") then
        self.playState:mousepressed(x, y, button)
    elseif GameState.is("gameover") then
        self:handleGameOverMousepress(x, y)
    end
end

function StateManager:handleMenuKeypress(key)
    if key == "space" then
        self:startGame()
    elseif key == "escape" then
        love.event.quit()
    end
end

function StateManager:handleMenuMousepress(x, y)
    -- Usar el nuevo método optimizado de Button
    for _, btn in ipairs(self.menuState.buttons) do
        if btn:isClicked(x, y) then
            btn.callback()
            break -- Early exit después del primer click
        end
    end
end

function StateManager:handleGameOverMousepress(x, y)
    for _, btn in ipairs(self.gameOverState.buttons) do
        if btn:isClicked(x, y) then
            btn.callback()
            break -- Early exit después del primer click
        end
    end
end

function StateManager:startGame()
    self.playState:reset()
    GameState.set("play")
end

-- Soporte para touch (móvil/tablet)
function StateManager:touchpressed(id, x, y, dx, dy, pressure)
    -- Mapear touch a mouse click
    self:mousepressed(x, y, 1)
end

function StateManager:touchreleased(id, x, y, dx, dy, pressure)
    -- Si necesitas manejar release del touch, aquí sería
    -- Por ahora solo necesitamos el press para los clicks
end

return StateManager