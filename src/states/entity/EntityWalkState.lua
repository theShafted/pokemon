EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity, level)
    self.entity = entity
    self.level = level
end

function EntityWalkState:enter()
    local X, Y = self.entity.mapX, self.entity.mapY
    local offsetX, offsetY = self.entity.offsetX, self.entity.offsetY

    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))

    if self.entity.direction == 'left' then X = X - 1
    elseif self.entity.direction == 'right' then X = X + 1
    elseif self.entity.direction == 'up' then Y = Y - 1
    else Y = Y + 1 end

    if X < 1 or X > 24 or Y < 2 or Y > 13 then
        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    self.entity.mapX, self.entity.mapY = X, Y

    Timer.tween(1/self.entity.speed, {
        [self.entity] = {x = ((X - 1) * TILE_SIZE)/2 - offsetX,
                         y = ((Y - 1) * TILE_SIZE)/2 - offsetY}
    }):finish(function()
        if love.keyboard.isDown('left') then
            self.entity.direction = 'left'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('right') then
            self.entity.direction = 'right'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('up') then
            self.entity.direction = 'up'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('down') then
            self.entity.direction = 'down'
            self.entity:changeState('walk')
        else self.entity:changeState('idle') end
    end)
end