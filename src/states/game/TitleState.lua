TitleState = Class{__includes = BaseState}

function TitleState:init()

    -- Initialize the background colors of the title screen
    self.colors = COLORS['black']

    -- Initialize properties for the game title
    self.title = {
        opacity = 0,
        position = {x = 0, y = (GAME_HEIGHT - FONTS.title)/2}
    }

    -- Initialize the pokemon with a random sprite and its x-y positions
    self.pokemon = {
        sprite = POKEMON_DATA[POKEMON_IDS[math.random(#POKEMON_IDS)]].frontSprite,
        x = (GAME_WIDTH - POKEMON_SPRITE_SIZE) / 2,
        y = GAME_HEIGHT / 2,
        opacity = 0
    }

    -- Initialize a particle system with a max buffer of paricles
    self.psystem = love.graphics.newParticleSystem(Textures['particle'], 500)
    self.destroyed = false

    --[[
        Behavioural functions for the particle system

        Sets a distribution for the particles and the max distance along x and y axes for emission
        Bounds the lifetime of each particle between two specified values
        Sets the acceleration of each particle along each axis
        Sets the amount of time for which the emitter should fire particles
        Bounds the linear speed of the particles between two specified values
    ]]
    self.psystem:setEmissionArea('normal', 0, 25)
    self.psystem:setParticleLifetime(0.5, 2.5)
    self.psystem:setLinearAcceleration(25, -10, 50, 10)
    self.psystem:setEmitterLifetime(2.5)
    self.psystem:setSpeed(25, 250)

    -- Tween the properties of the game title over the specified length of time with ease
    Timer.tween(2, {
        [self.title] = {opacity = 1}
    }):ease(Easing.inExpo)

    -- Waits for 0.5 seconds then runs the callback function
    Timer.after(0.5, function()

        -- Emit 100 new particles every 0.5 seconds
        Timer.every(0.5, function() self.psystem:emit(100) end):limit(5)
        :finish(function()

            -- Waits for 2 seconds before calling callback function
            Timer.after(2, function()

                -- Tweens the background color of the screen
                Timer.tween(1, {
                    [self.colors] = COLORS.white
                })

                -- Tweens the opacity of the game title after the particle system has finished firing particles with ease
                Timer.tween(1.5, {
                    [self.title.position] = {x = 0, y = 30},
                    [self.pokemon] = {opacity = 1}
                }):ease(Easing.outExpo)

                -- Destroys the particle systems' reference as it's no longer required
                self.destroyed = self.psystem:release()

                -- Change the position of and tween the pokemon sprite every 3 seconds
                Timer.every(3, function()

                    -- Tween the x position of the sprite with ease
                    Timer.tween(0.4, {
                        [self.pokemon] = {x = -64}
                    }):ease(Easing.outExpo)

                    -- Change the pokemon sprite and tween it after previous timer finishes
                    :finish(function()

                        -- Reinitialize the sprite and positions of the pokemon
                        self.pokemon = {
                            sprite = POKEMON_DATA[POKEMON_IDS[math.random(#POKEMON_IDS)]].frontSprite,
                            x = GAME_WIDTH,
                            y = GAME_HEIGHT / 2
                        }
            
                        -- Tween the new sprite with ease
                        Timer.tween(0.4, {
                            [self.pokemon] = {x = (GAME_WIDTH - POKEMON_SPRITE_SIZE) / 2}
                        }):ease(Easing.outExpo)
                    end)
                end)
            end)
        end)
    end)
end

function TitleState:update(dt)

    -- Method to update the particle system, creating, updating and killing particles
    if not self.destroyed then self.psystem:update(dt) end

    -- Start the routine for pushing the Play State when the 'enter' key is pressed
    if love.keyboard.keypressed('enter') or love.keyboard.keypressed('return') then
        Stack:push(FadeState(COLORS['white'], 0.5, 'in',
        function()

            -- Remove the Title Screen State from the stack
            Stack:pop()

            -- Add the Play State onto the stack
            Stack:push(PlayState())

            -- Add a fade out animation via a Fade State onto the stack
            Stack:push(FadeState(COLORS['white'], 0.5, 'out', function() end))
        end))
    end
end

-- Render method to draw onto the screen
function TitleState:render()

    -- Set Background color according to the tweens
    love.graphics.clear(self.colors.r, self.colors.g, self.colors.b)

    -- Draw the particle system at a specified position while it exists
    if not self.destroyed then
        love.graphics.draw(self.psystem, -100, GAME_HEIGHT/2)
    end

    -- Draw the game title with the specified properties
    love.graphics.setColor(1 - self.colors.r, 1 - self.colors.g, 1 - self.colors.b, self.title.opacity)
    love.graphics.setFont(Fonts['title'])
    love.graphics.printf("POKEMON", 0, self.title.position.y, GAME_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    -- Draw the "Press Enter" text on the screen
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(Fonts['small'])
    love.graphics.printf("PRESS ENTER", 0, GAME_HEIGHT - 20, GAME_WIDTH, 'center')

    -- Draw the pokemon sprites at a specified position
    love.graphics.setColor(1, 1, 1, self.pokemon.opacity)
    love.graphics.draw(Textures[self.pokemon.sprite], self.pokemon.x, self.pokemon.y)

    -- Reset the colors to default values
    love.graphics.setColor(1, 1, 1, 1)
end