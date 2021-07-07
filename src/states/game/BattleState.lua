BattleState = Class{__includes = BaseState}

function BattleState:init(player, opponent)
    self.player = player
    self.opponent = opponent
    self.started = false

    self.playerSprite = BattleSprite(self.player.party[1].backSprite, -64, GAME_HEIGHT - 110)
    self.opponentSprite = BattleSprite(self.opponent.party[1].frontSprite, GAME_WIDTH, 15)

    self.playerPokemon = self.player.party[1]
    self.opponentPokemon = self.opponent.party[1]

    self.bottomPanel = Panel(0, GAME_HEIGHT - 64, GAME_WIDTH, 64)
    self.playerHealthBar = Bar {
        x = GAME_WIDTH - 170,
        y = GAME_HEIGHT - 95,
        width = 152,
        height = 6,
        color = COLORS['health'],
        value = self.playerPokemon.currentHP,
        max = self.playerPokemon.HP
    }
    self.playerEXPBar = Bar {
        x = self.playerHealthBar.x + self.playerHealthBar.width - 75,
        y = self.playerHealthBar.y + self.playerHealthBar.height + 2,
        width = 75,
        height = 6,
        color = COLORS['exp'],
        value = self.playerPokemon.exp,
        max = self.playerPokemon.lvlUpExp
    }

    self.opponentHealthBar = Bar {
        x = 20,
        y = 20,
        width = 152,
        height = 6,
        color = COLORS['health'],
        value = self.opponentPokemon.currentHP,
        max = self.opponentPokemon.HP
    }

    self.renderHealthBars = false

    self.playerCircleX = -50
    self.opponentCircleX = GAME_WIDTH + 50
end

function BattleState:update(dt)
    if not self.started then self:slideIn() end
end

function BattleState:render()
    love.graphics.clear(214/255, 214/255, 214/255, 1)

    love.graphics.setColor(45/255, 184/255, 45/255, 124/255)
    love.graphics.ellipse('fill', self.opponentCircleX, 75, 72, 24)
    love.graphics.ellipse('fill', self.playerCircleX, GAME_HEIGHT - 50, 72, 24)

    love.graphics.setColor(1, 1, 1, 1)
    self.playerSprite:render()
    self.opponentSprite:render()

    if self.renderHealthBars then
        local x, y = self.playerHealthBar.x, self.playerHealthBar.y
        local width, height = self.playerHealthBar.width, self.playerHealthBar.height
        local pokemon = self.playerPokemon
        
        love.graphics.setColor(25/255, 25/255, 25/255, 1)
        love.graphics.rectangle('fill', x - 10, y - 20, width + 20, height + 40, 10)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(pokemon.name, x, y - 12)
        love.graphics.printf('Lv. ' .. pokemon.level, x, y - 12, width, 'right')
        love.graphics.print(pokemon.currentHP .. '/' .. pokemon.HP, x, y + height)

        local x, y = self.opponentHealthBar.x, self.opponentHealthBar.y
        local width, height = self.opponentHealthBar.width, self.opponentHealthBar.height
        local pokemon = self.opponentPokemon

        love.graphics.setColor(25/255, 25/255, 25/255, 1)
        love.graphics.rectangle('fill', x - 10, y - 17, width + 20, height + 25, 7)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(pokemon.name, x, y - 12)
        love.graphics.printf('Lv. ' .. pokemon.level, x, y - 12, width, 'right')
        
        self.playerHealthBar:render()
        self.opponentHealthBar:render()
        self.playerEXPBar:render()
    end
end

function BattleState:slideIn()
    self.started = true

    Timer.tween(1, {
        [self.opponentSprite] = {x = GAME_WIDTH - 100},
        [self] = {playerCircleX = 66, opponentCircleX = GAME_WIDTH - 70}
    }):ease(Easing.inExpo)
    :finish(function()
        self:start()
        self.renderHealthBars = true
    end)
end

function BattleState:start()
    local message = ''
    if self.opponent.wild then
        message = self.opponent.wild and 'A wild ' .. self.opponentPokemon.name .. ' appeared!'
    else
        message = 'You are challenged by trainer ' .. self.opponent.name .. '!'
    end

    Stack:push(MessageState(message, function()
        Stack:push(MessageState('Go ' .. self.playerPokemon.name .. '!', function()
            Timer.tween(0.5, {
                [self.playerSprite] = {x = 32}
            })
            Stack:push(MessageState('What will ' .. self.playerPokemon.name .. ' do?', function()
                Stack:push(BattleMenuState(self))
            end, false))
        end))
    end))
end