TurnState = Class{__includes = BaseState}

function TurnState:init(battleState)
    self.battleState = battleState

    self.playerPokemon = self.battleState.playerPokemon
    self.opponentPokemon = self.battleState.opponentPokemon

    self.playerSprite = battleState.playerSprite
    self.opponentSprite = battleState.opponentSprite

    if self.playerPokemon.speed >= self.opponentPokemon.speed then
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

function TurnState:enter(parameters)
    local moves = self.battleState.playerPokemon:getMoves()
    Stack:push(MessageState('Select a move', function()
        Stack:push(BattleMenuState(self.battleState, moves, function()
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
        
                    local message = 'What will ' .. self.battleState.playerPokemon.name .. ' do?'
                    Stack:push(MessageState(message, function()
                        Stack:push(BattleMenuState(self.battleState))
                    end, false))
                end)
            end)
        end))
    end, false))
end

function TurnState:attack(attacker, defender, callback)
    local message = attacker.pokemon.name .. ' used ' .. attacker.pokemon.move.name .. '!'
    Stack:push(MessageState(message, function() end, false))

    Timer.after(0.5, function()
        Timer.every(0.1, function()
            attacker.sprite.blink = not attacker.sprite.blink
        end)
        :limit(6)
        :finish(function()
            local x, y = 0, 0
            if attacker.pokemon == self.battleState.playerPokemon then
                x, y = attacker.sprite.x + 10, attacker.sprite.y - 10
            else
                x, y  = attacker.sprite.x - 10, attacker.sprite.y + 10
            end

            Timer.tween(0.5, {
                [attacker.sprite] = {x = x, y = y}
            })
            :ease(Easing.inExpo)
            :finish(function()
                if attacker.pokemon == self.battleState.playerPokemon then
                    x, y = attacker.sprite.x - 10, attacker.sprite.y + 10
                else
                    x, y  = attacker.sprite.x + 10, attacker.sprite.y - 10
                end

                Timer.tween(0.5, {
                    [attacker.sprite] = {x = x, y = y}
                })
                :ease(Easing.outExpo)

                Timer.every(0.1, function()
                    defender.sprite.opacity = defender.sprite.opacity == 64/255 and 1 or 64/255 
                end)
                :limit(6)

                local damage = self:damage(attacker.pokemon, defender.pokemon)
                Timer.tween(0.5, {
                    [defender.bar] = {value = math.floor(defender.pokemon.currentHP - damage)}
                })
                :finish(function()
                    defender.pokemon.currentHP = math.max(0, defender.pokemon.currentHP - damage)
                    
                    callback()
                end)
            end)
        end)
    end)            
end

function TurnState:damage(attacker, defender)
    return math.max(1, math.floor(attacker.attack / defender.defense * attacker.move.power))
end

function TurnState:checkDeath()
    if self.battleState.playerPokemon.currentHP <= 0 then
        self:faint()
        return true
    elseif self.battleState.opponentPokemon.currentHP <= 0 then
        self:victory()
        return true
    end

    return false
end

function TurnState:faint()
    local pokemon = self.battleState.playerPokemon
    
    Timer.tween(0.5, {
        [self.battleState.playerSprite] = {y = GAME_HEIGHT}
    })
    :ease(Easing.inExpo)
    :finish(function()
        Stack:push(MessageState(pokemon.name .. ' fainted!', function()
            Stack:push(FadeState(COLORS['black'], 1, 'in', function()
                pokemon.currentHP = pokemon.HP
                
                Stack:pop()
                Stack:push(MessageState('Your pokemon has been fully restored!'))
                Stack:push(FadeState(COLORS['black'], 1, 'out'))
            end))
        end))
    end)
end

function TurnState:victory()
    local pokemon, levelsGained = self.battleState.opponentPokemon, 0
    local exp = 10*pokemon.level * (pokemon.HPIV + pokemon.attackIV + pokemon.defenseIV + pokemon.speedIV)
    
    Timer.tween(1.5, {
        [self.battleState.opponentSprite] = {opacity = 0}
    })
    :ease(Easing.outExpo)

    Timer.after(0.1, function()
        Stack:push(MessageState(pokemon.name .. ' fainted!', function()
            Stack:push(MessageState('You got ' .. exp .. ' experience points!', nil, false))

            pokemon = self.battleState.playerPokemon
            exp = exp + pokemon.exp

            Timer.tween(1, {[self.battleState.playerEXPBar] = {value = math.min(exp, pokemon.lvlUpExp)}})
            :finish(function()
                Stack:pop()

                if exp >= pokemon.lvlUpExp then
                    while(exp > pokemon.lvlUpExp) do
                        exp = exp - pokemon.lvlUpExp
                        pokemon:levelUp()
                        levelsGained = levelsGained + 1
                    end
            
                    Stack:push(MessageState(pokemon.name .. ' grew to ' .. pokemon.level, function()
                        local learning = false

                        for name, level in pairs(pokemon.moves) do
                            local learned = false
                            for _, move in pairs(pokemon.learned) do
                                if move.name == name then learned = true end
                            end            

                            if not learned and level > pokemon.level - levelsGained then
                                learning = true
                                Stack:push(LearnState(pokemon, name, function()
                                    self.battleState.playerEXPBar.value = 0
                                    Timer.tween(1, {[self.battleState.playerEXPBar] = {value = exp}})
                                    :finish(function()
                                        pokemon.exp = exp
            
                                        if levelsGained > 0 and pokemon.level >= pokemon.evolveLv then
                                            self:fadeOut(pokemon)
                                        else
                                            self:fadeOut()
                                        end
                                    end)
                                end))
                            end
                        end
                        
                        if not learning then
                            self.battleState.playerEXPBar.value = 0
                            Timer.tween(1, {[self.battleState.playerEXPBar] = {value = exp}})
                            :finish(function()
                                pokemon.exp = exp

                                if levelsGained > 0 and pokemon.level >= pokemon.evolveLv then
                                    self:fadeOut(pokemon)
                                else
                                    self:fadeOut()
                                end
                            end)
                        end
                    end))
                else
                    pokemon.exp = exp
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