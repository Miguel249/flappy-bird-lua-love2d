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

    local assets = Assets.new()

    local buttons = {
        Button.new(assets.ui.buttonPlay, assets.ui.buttonPlayHover, function()
            self:startGame()
        end),
        Button.new(assets.ui.buttonExit, assets.ui.buttonExitHover, function()
            love.event.quit()
        end),
    }

    self.menuState = MenuState.new(buttons)
    self.playState = PlayState.new()
    self.gameOverState = GameOverState.new(self.playState)

    GameState.set("menu")

    return self
end

function StateManager:update(dt)
    if GameState.is("menu") then
        -- El menu no necesita update por ahora
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
    if GameState.is("menu") then
        self:handleMenuMousepress(x, y, button)
    elseif GameState.is("play") then
        self.playState:mousepressed(x, y, button)
    elseif GameState.is("gameover") then
        self.gameOverState:mousepressed(x, y, button)
    end
end

function StateManager:handleMenuKeypress(key)
    if key == "space" then
        self:startGame()
    elseif key == "escape" then
        love.event.quit()
    end
end

function StateManager:handleMenuMousepress(x, y, button)
    if button == 1 then
        for _, btn in ipairs(self.menuState.buttons) do
            if btn.x and btn.y and btn.width and btn.height then
                if x > btn.x and x < btn.x + btn.width and
                    y > btn.y and y < btn.y + btn.height then
                    btn.callback()
                end
            end
        end
    end
end

function StateManager:startGame()
    self.playState:reset()
    GameState.set("play")
end

return StateManager
