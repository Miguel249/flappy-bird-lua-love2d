local Assets = {}
local instance = nil

function Assets.getInstance()
    if not instance then
        instance = Assets._new()
    end
    return instance
end

function Assets._new()
    local self = {}

    local bgImage = love.graphics.newImage("assets/ui/background.png")
    local bgScale = love.graphics.getHeight() / bgImage:getHeight()
    local bgScaledWidth = bgImage:getWidth() * bgScale
    local flImage = love.graphics.newImage("assets/ui/floor.png")
    local flScale = love.graphics.getHeight() / flImage:getHeight()
    local flScaledWidth = flImage:getWidth() * flScale

    self.ui = {
        background = {
            image = bgImage,
            scale = {
                bgScale = bgScale,
                bgScaledWidth = bgScaledWidth
            },
            bgScroll = 0,
            bgSpeed = 30
        },
        floor = {
            image = flImage,
            scale = {
                flScale = flScale,
                flScaledWidth = flScaledWidth,
            },
            flScroll = 0,
            flSpeed = 100
        },
        logo = love.graphics.newImage("assets/ui/logo.png"),
        skull = love.graphics.newImage("assets/ui/pollo.png"),
        infernalPipe = love.graphics.newImage("assets/ui/infernal_pipe2.png"),
        buttonPlayHover = love.graphics.newImage("assets/ui/button_play_hover.png"),
        buttonPlay = love.graphics.newImage("assets/ui/button_play.png"),
        buttonExitHover = love.graphics.newImage("assets/ui/button_exit_hover.png"),
        buttonExit = love.graphics.newImage("assets/ui/button_exit.png"),
        buttonMenuHover = love.graphics.newImage("assets/ui/button_menu_hover.png"),
        buttonMenu = love.graphics.newImage("assets/ui/button_menu.png"),
        buttonRestartHover = love.graphics.newImage("assets/ui/button_restart_hover.png"),
        buttonRestart = love.graphics.newImage("assets/ui/button_restart.png"),
        gameOver = love.graphics.newImage("assets/ui/gameover.png")
    }

    self.ui.background.image:setWrap("repeat", "clamp")
    self.ui.floor.image:setWrap("repeat", "clamp")

    local texture = self.ui.infernalPipe
    if texture then
        local texWidth = texture:getWidth()
        local texHeight = texture:getHeight()
        local borderHeight = math.floor(texHeight / 4.3)
        local repeatableHeight = texHeight - borderHeight

        self.pipeQuads = {
            border = love.graphics.newQuad(0, repeatableHeight, texWidth, borderHeight, texWidth, texHeight),
            repeatable = love.graphics.newQuad(0, 0, texWidth, repeatableHeight, texWidth, texHeight)
        }
    end

    return self
end

return Assets
