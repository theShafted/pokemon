ChangePokemonState = Class{__includes = BaseState}

function ChangePokemonState:init(battleState)
    self.battleState = battleState
    
    self.panel = Panel(0, GAME_HEIGHT, GAME_WIDTH, 50)
end

function ChangePokemonState:enter()
    Timer.tween(0.5, {[self.panel] = {y = GAME_HEIGHT - 101}})
    :finish(function()
        Stack:push(BattleMenuState(nil, {
            x = 3,
            y = self.panel.y + 3,
            width = self.panel.width - 3, 
            height = 44,
            orientation = 'horizontal',
            font = Fonts['tiny'],
            items = self:getParty()
        }))
    end)
end

function ChangePokemonState:render() 
    if self.panel.y <= GAME_HEIGHT - 50 then
        self.panel:render() 
    end
end

function ChangePokemonState:getParty()
    local party = {}

    for _, pokemon in ipairs(self.battleState.player.party) do
        table.insert(party, {
            text = pokemon.name .. '\nHP: ' .. pokemon.currentHP .. '/' .. pokemon.HP .. '\n' .. 'Lv: ' .. pokemon.level,
            selected = function()
                Stack:pop()
                Stack:pop()
                Stack:pop()

                if pokemon ~= self.battleState.playerPokemon then
                    Timer.tween(0.5, {[self.battleState.playerSprite] = {y = GAME_HEIGHT}})
                    :finish(function()
                        self.battleState.playerPokemon = pokemon
                        self.battleState.playerSprite = BattleSprite(pokemon.backSprite, -64, GAME_HEIGHT - 110)

                        self.battleState.playerHealthBar.value = pokemon.currentHP
                        self.battleState.playerHealthBar.max = pokemon.HP

                        self.battleState.playerEXPBar.value = pokemon.exp
                        self.battleState.playerEXPBar.max = pokemon.lvlUpExp

                        self.battleState:start(true)
                    end)
                else
                    self.battleState:start(false)
                end
            end
        })
    end

    return party
end