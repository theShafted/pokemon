Move = Class()

function Move:init(parameters)
    self.name = parameters.name
    self.power = parameters.power
    self.accuracy = parameters.accuracy
    
    self.battleState = parameters.battleState

    self.attacker = parameters.attacker
    self.defender = parameters.defender
end

function Move:start()
    Timer.every(0.1, function()
        self.attacker.sprite.blink = not self.attacker.sprite.blink
    end)
    :limit(6)
    :finish(function()
        local x, y = 0, 0
        if self.attacker.pokemon == self.battleState.playerPokemon then
            x, y = self.attacker.sprite.x + 10, self.attacker.sprite.y - 10
        else
            x, y  = self.attacker.sprite.x - 10, self.attacker.sprite.y + 10
        end

        Timer.tween(0.5, {
            [self.attacker.sprite] = {x = x, y = y}
        })
        :ease(Easing.inExpo)
        :finish(function()
            if self.attacker.pokemon == self.battleState.playerPokemon then
                x, y = self.attacker.sprite.x - 10, self.attacker.sprite.y + 10
            else
                x, y  = self.attacker.sprite.x + 10, self.attacker.sprite.y - 10
            end

            Timer.tween(0.5, {
                [self.attacker.sprite] = {x = x, y = y}
            })
            :ease(Easing.outExpo)

            Timer.every(0.1, function()
                self.defender.sprite.opacity = self.defender.sprite.opacity == 64/255 and 1 or 64/255 
            end):limit(6)
            :finish(function() Stack:pop() end)
        end)
    end)
end

function Move:update(dt) end

function Move:render() end