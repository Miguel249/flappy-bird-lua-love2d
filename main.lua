-- main.lua - Versión refactorizada
local StateManager = require("src.states.StateManager")

local stateManager

function love.load()
    stateManager = StateManager.new()
end

function love.update(dt)
    stateManager:update(dt)
end

function love.draw()
    -- En love.draw() puedes agregar:
    print("FPS: " .. love.timer.getFPS(), 10, 10)
    print("Memory: " .. math.floor(collectgarbage("count")) .. "KB", 10, 30)
    stateManager:draw()
end

function love.keypressed(key)
    stateManager:keypressed(key)
end

function love.mousepressed(x, y, button)
    stateManager:mousepressed(x, y, button)
end
