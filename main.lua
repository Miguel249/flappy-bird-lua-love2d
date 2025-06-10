local Bird = require("src.Bird")
local Pipe = require("src.Pipe")
local GameState = require("src.GameState")

local ui = {
    background = nil,
    buttonPlay = nil,
    buttonPlayHover = nil,
    buttonExit = nil,
    buttonExitHover = nil,
    title = nil
}
local buttons = {}


local bgScroll = 0
local bgSpeed = 30
local bgScale
local bgScaledWidth

local bird
local pipes = {}
local pipeTimer = 0
local fontLarge
local fontMedium

function love.load()
    ui.background = love.graphics.newImage("assets/ui/background.png")
    ui.logo = love.graphics.newImage("assets/ui/logo.png")
    ui.buttonPlayHover = love.graphics.newImage("assets/ui/button_play_hover.png")
    ui.buttonPlay = love.graphics.newImage("assets/ui/button_play.png")
    ui.buttonExitHover = love.graphics.newImage("assets/ui/button_exit_hover.png")
    ui.buttonExit = love.graphics.newImage("assets/ui/button_exit.png")
    ui.background:setWrap("repeat", "clamp")

    buttons = {
        {
            image = ui.buttonPlay,
            hoverImage = ui.buttonPlayHover,
            action = function()
                StartGame()
            end
        },
        {
            image = ui.buttonExit,
            hoverImage = ui.buttonExitHover,
            action = function()
                love.event.quit()
            end
        }
    }

    bird = Bird.new()

    local bgOriginalHeight = ui.background:getHeight()
    local windowHeight = love.graphics.getHeight()
    bgScale = windowHeight / bgOriginalHeight

    bgScaledWidth = ui.background:getWidth() * bgScale

    fontLarge = love.graphics.newFont(36)
    fontMedium = love.graphics.newFont(22)
    GameState.set("menu")
end

function love.update(dt)
    if GameState.is("play") then
        bgScroll = (bgScroll + bgSpeed * dt) % bgScaledWidth

        bird:update(dt)
        pipeTimer = pipeTimer + dt

        if pipeTimer > 2 then
            table.insert(pipes, Pipe.new())
            pipeTimer = 0
        end

        for i = #pipes, 1, -1 do
            local pipe = pipes[i]
            pipe:update(dt)

            if pipe:isOffScreen() then
                table.remove(pipes, i)
            elseif pipe:collidesWith(bird) then
                GameState.set("gameover")
            end
        end

        if bird.y + bird.height >= love.graphics.getHeight() then
            GameState.set("gameover")
        end
    end
end

function love.draw()
    if GameState.is("menu") then
        DrawMenu()
    elseif GameState.is("play") then
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(ui.background, -bgScroll, 0, 0, bgScale, bgScale)
        love.graphics.draw(ui.background, -bgScroll + bgScaledWidth, 0, 0, bgScale, bgScale)
        bird:draw()
        for _, pipe in ipairs(pipes) do
            pipe:draw()
        end
    elseif GameState.is("gameover") then
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(ui.background, -bgScroll, 0, 0, bgScale, bgScale)
        love.graphics.draw(ui.background, -bgScroll + bgScaledWidth, 0, 0, bgScale, bgScale)
        bird:draw()
        for _, pipe in ipairs(pipes) do
            pipe:draw()
        end

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(fontLarge)
        love.graphics.printf("¡Game Over!", 0, 120, love.graphics.getWidth(), "center")

        love.graphics.setFont(fontMedium)
        love.graphics.printf("[R] Reiniciar", 0, 200, love.graphics.getWidth(), "center")
        love.graphics.printf("[M] Menú", 0, 230, love.graphics.getWidth(), "center")
        love.graphics.printf("[ESC] Salir", 0, 260, love.graphics.getWidth(), "center")
    end
end

function DrawMenu()
    love.graphics.clear(0.2, 0.6, 0.9)

    local windowWidth = 400

    if ui.logo then
        local logoScale = 250 / ui.logo:getWidth()
        local logoX = (windowWidth - ui.logo:getWidth() * logoScale) / 2
        local logoY = 40
        love.graphics.draw(ui.logo, logoX, logoY, 0, logoScale, logoScale)
    end

    local mx, my = love.mouse.getPosition()
    local spacing = 50
    local yStart = 230

    for i, btn in ipairs(buttons) do
        if btn.image then
            local scale = 250 / btn.image:getWidth()
            local bw = btn.image:getWidth() * scale
            local bh = btn.image:getHeight() * scale
            local x = (windowWidth - bw) / 2
            local y = yStart + (i - 1) * (bh + spacing)

            btn.width = bw
            btn.height = bh
            btn.x = x
            btn.y = y

            local hovered = mx > x and mx < x + bw and my > y and my < y + bh
            local image = hovered and btn.hoverImage or btn.image
            love.graphics.draw(image, x, y, 0, scale, scale)
        end
    end
end

function love.keypressed(key)
    if GameState.is("menu") then
        if key == "space" then StartGame() end
        if key == "escape" then love.event.quit() end
    elseif GameState.is("play") then
        if key == "space" then bird:flap() end
    elseif GameState.is("gameover") then
        if key == "r" then StartGame() end
        if key == "m" then GameState.set("menu") end
        if key == "escape" then love.event.quit() end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and GameState.is("menu") then
        for _, btn in ipairs(buttons) do
            if btn.x and btn.y and btn.width and btn.height then
                if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                    btn.action()
                end
            end
        end
    elseif GameState.is("play") then
        bird:flap()
    end
end

function StartGame()
    bird = Bird.new()
    pipes = {}
    pipeTimer = 0
    GameState.set("play")
end
