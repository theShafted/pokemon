require 'src/imports'

function love.load()

    -- Setup the resolution using the push library
    Push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        fullscreen = true,
        vsync = true,
        resizable = true
    })

    -- Sets filtering mode to nearest neighbour for crisp sprites
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Table to handle keyboard inputs outside of 'main.lua'
    love.keyboard.keyspressed = {}

    -- Flag to check if game is paused
    paused = false
end

-- Resizes the game window using the push library
function love.resize(width, height)
    Push:resize(width, height)
end

function love.keypressed(key)

    -- Quit the game if the 'esc' key is pressed
    if key == 'escape' then love.event.quit() end

    -- Toggle the paused state whenever the 'p' key is pressed
    if key == 'p' then paused = not paused end

    -- Update the keys table according to the key pressed
    love.keyboard.keyspressed[key] = true
end

-- Function to check for keyboard inputs outside of 'main.lua'
function love.keyboard.keypressed(key)
    return love.keyboard.keyspressed[key]
end

function love.update(dt)

    -- Updates the game state only if it isn't paused
    if not paused then love.keyboard.keyspressed = {} end
end

function love.draw()

    -- Starts rendering using the Game dimensions
    Push:start()

    -- Sets font to the title font and prints the title onto the screen
    love.graphics.setFont(Fonts['title'])
    love.graphics.printf("POKEMON", 0, GAME_HEIGHT/2 - 32, GAME_WIDTH, 'center')

    -- Stops using the push library for rendering
    Push:finish()
end