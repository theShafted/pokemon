Entity = Class()

function Entity:init(parameters)
    self.direction = 'down'

    self.mapX = parameters.mapX
    self.mapY = parameters.mapY

    self.width = parameters.width
    self.height = parameters.height

    self.offsetX = parameters.offsetX or 0
    self.offsetY = parameters.offsetY or 0

    self.scaleX = parameters.scaleX or 1
    self.scaleY = parameters.scaleY or 1

    self.animations = self:initAnimation(parameters.animations)
    self.currentAnimation = nil

    self.x = ((self.mapX - 1) * TILE_SIZE) * self.scaleX - self.offsetX
    self.y = ((self.mapY - 1) * TILE_SIZE) * self.scaleY - self.offsetY

    self.speed = PLAYER_WALK_SPEED

    self.stateMachine = parameters.stateMachine
end

function Entity:changeState(name) self.stateMachine:change(name) end

function Entity:changeAnimation(animation) self.currentAnimation = self.animations[animation] end

function Entity:initAnimation(animations)
    local result = {}

    for k, data in pairs(animations) do
        result[k] = Animation {
            texture = data.texture,
            frames = data.frames,
            interval = data.interval
        }
    end

    return result
end

function Entity:onInteract() end

function Entity:processAI(params, dt) self.stateMachine:processAI(params, dt) end

function Entity:update(dt)
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render() self.stateMachine:render() end