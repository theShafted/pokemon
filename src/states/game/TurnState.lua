TurnState = Class{__includes = BaseState}

function TurnState:init(battleState)
    self.battleState = battleState

    self.playerPokemon = self.battleState.playerPokemon
    self.opponentPokemon = self.battleState.opponentPokemon

    self.playerSprite = battleState.playerSprite
    self.opponentSprite = battleState.opponentSprite

    self.playerSpeed = self.playerPokemon.speed * MODIFIERS[self.playerPokemon.modifiers.speed]
    self.opponentSpeed = self.opponentPokemon.speed * MODIFIERS[self.opponentPokemon.modifiers.speed]

    if self.playerSpeed >= self.opponentSpeed then
        self.first = {
            pokemon = self.playerPokemon,
            sprite = self.playerSprite,
            bar = self.battleState.playerHealthBar
        }

        self.second = {
            pokemon = self.opponentPokemon,
            sprite = self.opponentSprite,
            bar = self.battleState.opponentHealthBar
        }
    else
        self.second = {
            pokemon = self.playerPokemon,
            sprite = self.playerSprite,
            bar = self.battleState.playerHealthBar
        }

        self.first = {
            pokemon = self.opponentPokemon,
            sprite = self.opponentSprite,
            bar = self.battleState.opponentHealthBar
        }
    end
end

function TurnState:enter()
    local moves = self.playerPokemon:getMoves()

    Stack:push(MessageState('Select a move', function()
        Stack:push(BattleMenuState(self.battleState, {items = moves}, function()
            Stack:pop()
            Stack:pop()

            self:attack(self.first, self.second, function()
                Stack:pop()
                
                if self:checkDeath() then
                    Stack:pop()
                    return 
                end
        
                self:attack(self.second, self.first, function()
                    Stack:pop()
                    
                    if self:checkDeath() then
                        Stack:pop()
                        return 
                    end
                    Stack:pop()
        
                    local message = 'What will ' .. self.playerPokemon.name .. ' do?'
                    Stack:push(MessageState(message, function() Stack:push(BattleMenuState(self.battleState)) end, false))
                end)
            end)
        end))
    end, false))
end

function TurnState:attack(attacker, defender, callback)
    local message = attacker.pokemon.name .. ' used ' .. attacker.pokemon.move.name .. '!'
    Stack:push(MessageState(message, nil, false))

    Timer.after(0.5, function()
        Timer.every(0.1, function()
            attacker.sprite.blink = not attacker.sprite.blink
        end)
        :limit(6)
        :finish(function()
            local x, y = 0, 0
            if attacker.pokemon == self.playerPokemon then x, y = attacker.sprite.x + 10, attacker.sprite.y - 10
            else x, y  = attacker.sprite.x - 10, attacker.sprite.y + 10 end

            Timer.tween(0.5, {[attacker.sprite] = {x = x, y = y}})
            :ease(Easing.inExpo)
            :finish(function()
                if attacker.pokemon == self.playerPokemon then x, y = attacker.sprite.x - 10, attacker.sprite.y + 10
                else x, y  = attacker.sprite.x + 10, attacker.sprite.y - 10 end

                Timer.tween(0.5, {[attacker.sprite] = {x = x, y = y}})
                :ease(Easing.outExpo)

                Timer.every(0.1, function()
                    defender.sprite.opacity = defender.sprite.opacity == 64/255 and 1 or 64/255 
                end)
                :limit(6)

                local damage = attacker.pokemon:getDamage(attacker.pokemon.move, defender.pokemon)
                local wait = attacker.pokemon.isCritical and 0.5 or 0
                
                if attacker.pokemon.move.type == 'damage' then
                    Timer.tween(0.5, {
                        [defender.bar] = {value = math.floor(defender.pokemon.currentHP - damage)}
                    })
                    :finish(function()
                        Timer.after(wait, function()
                            if wait > 0 then Stack:pop() end

                            defender.pokemon.currentHP = math.max(0, defender.pokemon.currentHP - damage)
                            callback()
                        end)
                    end)
                else
                    Timer.after(1, function()
                        Stack:pop()
                        Timer.after(wait, function()
                            if wait > 0 then Stack:pop() end
                            callback()
                        end)
                    end)
                end
            end)
        end)
    end)            
end

function TurnState:checkDeath()
    if self.playerPokemon.currentHP <= 0 then
        self.playerPokemon:resetModifiers()
        self:faint()
        return true
    elseif self.opponentPokemon.currentHP <= 0 then
        self.playerPokemon:resetModifiers()
        self:victory()
        return true
    end

    return false
end

function TurnState:faint()
    Timer.tween(0.5, {
        [self.playerSprite] = {y = GAME_HEIGHT}
    })
    :ease(Easing.inExpo)
    :finish(function()
        Stack:push(MessageState(self.playerPokemon.name .. ' fainted!', function()
            Stack:push(FadeState(COLORS['black'], 1, 'in', function()
                self.playerPokemon.currentHP = self.playerPokemon.HP
                
                Stack:pop()

                Stack:push(MessageState('Your pokemon has been fully restored!'))
                Stack:push(FadeState(COLORS['black'], 1, 'out'))
            end))
        end))
    end)
end

function TurnState:victory()
    Timer.tween(1.5, {
        [self.opponentSprite] = {opacity = 0}
    })
    :ease(Easing.outExpo)

    Timer.after(0.1, function()
        local exp = self.playerPokemon:getExp(self.opponentPokemon)

        Stack:push(MessageState(self.opponentPokemon.name .. ' fainted!', function()
            Stack:push(MessageState('You got ' .. exp .. ' experience points!', nil, false))
            self.playerPokemon.exp = exp + self.playerPokemon.exp

            local max = self.battleState.playerEXPBar.max
            Timer.tween(1, {[self.battleState.playerEXPBar] = {value = math.min(self.playerPokemon.exp, max)}})
            :finish(function()
                Stack:pop()

                if self.playerPokemon.exp >= self.playerPokemon.lvlUpExp then
                    Stack:push(LevelUpState(self.battleState, function(evolution) self:fadeOut(evolution) end))
                else
                    self:fadeOut()
                end
            end)
        end))
    end)
end

function TurnState:fadeOut(evolution)
    Stack:push(FadeState(COLORS['black'], 1, 'in', function()
        Stack:pop()

        if evolution ~= nil then Stack:push(EvolveState(evolution)) end
        Stack:push(FadeState(COLORS['black'], 1, 'out'))
    end))
end