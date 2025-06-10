local Assets = {}
Assets.__index = Assets

function Assets.new()
    local self = setmetatable({}, Assets)

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
        buttonPlayHover = love.graphics.newImage("assets/ui/button_play_hover.png"),
        buttonPlay = love.graphics.newImage("assets/ui/button_play.png"),
        buttonExitHover = love.graphics.newImage("assets/ui/button_exit_hover.png"),
        buttonExit = love.graphics.newImage("assets/ui/button_exit.png"),
    }

    self.ui.background.image:setWrap("repeat", "clamp")
    self.ui.floor.image:setWrap("repeat", "clamp")
    return self
end

return Assets
