-- Initiate the StateMachine as a class
StateMachine = Class()

-- Constructor method for the StateMachine class
function StateMachine:init(states)

    -- Initialize the current state as an empty state
    self.current = {

        -- Empty state holds all methods as anonymous function
        enter = function() end,
        update = function() end,
        render = function() end,
        exit = function() end
    }

    -- Store all the states taken as input during the instantiation of the StateMachine
    self.states = states or {}
end

--  Method used to change the current state
function StateMachine:change(state, parameters)
    
    --[[
        Call the exit method of the previous state and change the current state
        Call the enter method of the current state passing input parameters if any
    ]]
    self.current:exit()
    self.current = self.states[state]()
    self.current:enter(parameters)
end

-- Method used to update the current state
function StateMachine:update(dt)

    -- Call the update method on the curent state
    self.current:update(dt)
end

-- Method to render the current state
function StateMachine:render()

    -- Call the render method on the current state
    self.current:render()
end