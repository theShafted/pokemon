-- Initiate the StateStack as a Class
StateStack = Class()

-- Constructor function for the stack class
function StateStack:init()

    -- Initially the stack contains an empty table to hold all the states
    self.states = {}
end

-- Push method to add a new state on top of the stack
function StateStack:push(state, parameters)

    --[[
        Adds the new state to the states table
        Call the enter method of the state passing input parameters if any
    ]]
    table.insert(self.states, state)
    state:enter(parameters)
end

-- Pop method to remove the newest state of the stack
function StateStack:pop()

    --[[
        Call the exit method of the state to be removed first
        Removes the last state from the states table
    ]]
    self.states[#self.states]:exit()
    table.remove(self.states)
end

-- Update method to update the StateStack
function StateStack:update(dt)

    -- Call the update method on only the last state of the stack
    self.states[#self.states]:update(dt)
end

-- Render method to render all states present in the stack at any point in time
function StateStack:render()

    --[[
        Iterates through all of the states in the states table in order
        Calls the render method of each state to render
    ]]
    for _, state in ipairs(self.states) do state:render() end
end