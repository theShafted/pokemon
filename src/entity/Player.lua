Player = Class{__includes = Entity}

function Player:init(parameters)
    Entity.init(self, parameters)

    self.party = {Pokemon(POKEMON_DATA['rockitten'], 5)}
end

function Player:update(dt)
    self.speed = love.keyboard.isDown('space') and PLAYER_RUN_SPEED or PLAYER_WALK_SPEED
    Entity.update(self, dt)
end