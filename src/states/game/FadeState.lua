-- Initiate the Fade Screens as a Class which inherits from BaseState class
FadeState = Class{__includes = BaseState}

--Constructor function for the Fade State
function FadeState:init(color, time, type, callback)
    
    -- RGB values for the color from which to begin fading
    self.r = color.r
    self.g = color.g
    self.b = color.b

    -- Opacity values to determine whether to fade in or out
    self.opacity = type == 'in' and 0 or 1

    -- Time duration for the fading animation
    self.time = time

    -- Tween the opacity of the fade in the specified time
    Timer.tween(self.time, {

        -- Determine the opacity depending on the fade type
        [self] = {opacity = type == 'in' and 1 or 0}
    })

    -- call the callback function and pop the Fade State after the tween finishes
    :finish(function()
        Stack:pop()
        callback()
    end)
end

-- Render method to draw the Fade animations onto the screen
function FadeState:render()

    -- Set the colors to draw a rectangle covering the entire screen whose opacity is tweened
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, GAME_WIDTH, GAME_HEIGHT)

    -- Reset the colors to their default values
    love.graphics.setColor(1, 1, 1, 1)
end