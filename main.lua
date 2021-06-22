function love.load()

    -- Randomseed generator
    math.randomseed(os.time())

    -- Sets filtering mode to nearest neighbour for crisp sprites
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Imports all files and classes in the project
    require 'src/imports'

    -- Setup the resolution using the push library
    Push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        fullscreen = true,
        vsync = true,
        resizable = true
    })

    -- Flag to check if game is paused
    paused = false

    Stack = StateStack()
    Stack:push(TitleState())

    -- Table to handle keyboard inputs outside of 'main.lua'
    love.keyboard.keyspressed = {}
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
    if not paused then
        Timer.update(dt)
        Stack:update(dt)

        love.keyboard.keyspressed = {}
    end
end

function love.draw()

    -- Starts rendering using the Game dimensions
    Push:start()

    Stack:render()
    -- Stops using the push library for rendering
    Push:finish()
end