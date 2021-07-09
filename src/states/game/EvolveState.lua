EvolveState = Class{__includes = BaseState}

function EvolveState:init(pokemon)
    self.pokemon = pokemon
    self.evolution = POKEMON_DATA[pokemon.evolveID]
    
    self.sprite = BattleSprite(pokemon.frontSprite, GAME_WIDTH/2 - 32, GAME_HEIGHT/2 - 32)
    self.evolutionSprite = BattleSprite(self.evolution.frontSprite, GAME_WIDTH/2 - 32, GAME_HEIGHT/2 - 32)

    self.psystem = love.graphics.newParticleSystem(Textures['particle'], 500)
    self.destroyed = false

    self.psystem:setEmissionArea('normal', 5, 5, 2 * math.pi, true)
    self.psystem:setParticleLifetime(0.5, 5)
    self.psystem:setEmitterLifetime(5)
    self.psystem:setSpeed(25, 100)
end

function EvolveState:enter()
    self.evolutionSprite.opacity = 0
    self.evolutionSprite.blink = true

    Stack:push(MessageState(self.pokemon.name .. ' is evolving!', function()
        Timer.after(1, function()
            Timer.every(0.1, function() self.sprite.blink = not self.sprite.blink end):limit(25)
            Timer.every(0.5, function() self.psystem:emit(100) end):limit(10)
            Timer.after(2.5, function()
                Timer.tween(2.5, {
                    [self.sprite] = {opacity = 0},
                    [self.evolutionSprite] = {opacity = 1}
                })
                :ease(Easing.inExpo)
                :finish(function()
                    self.evolutionSprite.blink = false
                    self.destroyed = self.psystem:release()

                    local message = self.pokemon.name .. ' evolved into ' .. self.evolution.name .. '!'
                    Stack:push(MessageState(message, function()
                        Stack:push(FadeState(COLORS['white'], 0.5, 'in', function()
                            Stack:pop()
                            Stack:push(FadeState(COLORS['white'], 0.5, 'out'))
                        end))
                    end))
                end)
            end)
        end)
    end))
end

function EvolveState:update(dt)
    if not self.destroyed then self.psystem:update(dt) end
end

function EvolveState:render()
    love.graphics.clear(0, 0, 0, 1)

    if not self.destroyed then
        self.sprite:render()
        love.graphics.draw(self.psystem, GAME_WIDTH/2, GAME_HEIGHT/2)
    end

    self.evolutionSprite:render()
end