local Shaders = {}
local instance = nil

function Shaders.getInstance()
    if not instance then
        instance = Shaders._new()
    end
    return instance
end

function Shaders._new()
    local self = {}

    self.blurShader = love.graphics.newShader("assets/shaders/blur.frag")

    self.blurShader:send("radius", 0.5)
    self.blurShader:send("directionX", 1)
    self.blurShader:send("directionY", 1)
    return self
end

return Shaders