LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(battleState, callback)
    self.battleState = battleState
    self.callback = callback

    self.pokemon = self.battleState.playerPokemon
end

function LevelUpState:enter()
    self.pokemon.exp = self.pokemon.exp - self.pokemon.lvlUpExp

    local HP, attack, defense, speed = self.pokemon:levelUp()

    Stack:push(MessageState(self.pokemon.name .. ' grew to ' .. self.pokemon.level, function()
        Stack:push(BattleMenuState(nil, {
            x = GAME_WIDTH - 180,
            y = 3,
            height = GAME_HEIGHT - 118,
            width = 152,
            orientation = 'vertical',
            items = {
                {
                    text = 'HP: ' .. self.pokemon.HP - HP .. ' + ' .. HP .. ' = ' .. self.pokemon.HP,
                    selected = function() self:checkMoves() end
                },
                {
                    text = 'Attack: ' .. self.pokemon.attack - attack .. ' + ' .. attack .. ' = ' .. self.pokemon.attack,
                    selected = function() end
                },
                {
                    text = 'Defense: ' .. self.pokemon.defense - defense .. ' + ' .. defense .. ' = ' .. self.pokemon.defense,
                    selected = function() end
                },
                {
                    text = 'Speed: ' .. self.pokemon.speed - speed .. ' + ' .. speed .. ' = ' .. self.pokemon.speed,
                    selected = function() end
                }
            }
        },
        nil, false))
    end))
end

function LevelUpState:checkMoves()
    Stack:pop()
    
    local newMove, learned = nil, false
    for name, level in pairs(self.pokemon.moves) do
        learned = false
        
        for _, move in pairs(self.pokemon.learned) do
            if move.name == name then learned = true end
        end

        if not learned and level == self.pokemon.level then newMove = name end
    end

    if newMove ~= nil then
        Stack:push(LearnState(self.pokemon, newMove, function() self:checkLevels() end))
    else
        self:checkLevels()
    end
end

function LevelUpState:checkLevels()
    self.battleState.playerEXPBar.value = 0
    self.battleState.playerEXPBar:tween(1, self.pokemon.exp, function()
        if self.pokemon.exp < self.pokemon.lvlUpExp then
            Stack:pop()

            local evolution = nil
            if self.pokemon.level >= self.pokemon.evolveLv then evolution = self.pokemon end
            
            self.callback(evolution)
        else
            self:enter()
        end
    end)           
end