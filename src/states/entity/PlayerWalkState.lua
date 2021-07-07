PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity, level)
    EntityWalkState.init(self, entity, level)
    self.encounter = false
end

function PlayerWalkState:enter()
    self:checkEncounter()
    if not self.encounter then self:move() end
end

function PlayerWalkState:checkEncounter()
    local x, y = self.entity.mapX, self.entity.mapY

    if self.level.grassLayer.tiles[y][x].id == TILES['grass'] and math.random(5) == 1 then
        self.entity:changeState('idle')

        Stack:push(FadeState(COLORS['black'], 1, 'in', 
        function()
            Stack:push(BattleState(self.entity, Opponent{
                party = {Pokemon.getRandom()},
                items = {},
                wild = true
            }))
            Stack:push(FadeState(COLORS['black'], 1, 'out', function() end))
        end))

        self.encounter = true
    else self.encounter = false end
end