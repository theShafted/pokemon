EntityBaseState = Class()

function EntityBaseState:init(entity) self.entity = entity end

function EntityBaseState:update(dt) end
function EntityBaseState:enter() end
function EntityBaseState:exit() end
function EntityBaseState:processAI(parameters, dt) end

function EntityBaseState:render()
    local sprite = self.entity.currentAnimation

    love.graphics.draw(Textures[sprite.texture], Frames[sprite.texture][sprite:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y),
        0, self.entity.scaleX, self.entity.scaleY)
end