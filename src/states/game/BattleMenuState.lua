BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState, parameters, callback, cursor)
    self.battleState = battleState or nil
    self.parameters = parameters or {
        x = 150, 
        y = GAME_HEIGHT - 68, 
        width = GAME_WIDTH - 150,
        height = 17,
        orientation = 'horizontal',
    }

    self.menu = Menu {
        callback = callback or function() end,
        x = self.parameters.x or 150,
        y = self.parameters.y or GAME_HEIGHT - 68,
        width = self.parameters.width or GAME_WIDTH - 150,
        height = self.parameters.height or 17,
        orientation = self.parameters.orientation or 'horizontal',
        cursor = cursor == nil and true or cursor,
        items = self.parameters.items or {
            {
                text = "ATTACK",
                selected = function()
                    Stack:pop()
                    Stack:pop()
                    Stack:push(TurnState(self.battleState))
                end
            },
            {
                text = "POKEMON",
                selected = function() end
            },
            {
                text = "BAG",
                selected = function() end
            },
            {
                text = "RUN",
                selected = function()
                    if math.random(5) == 1 then
                        Stack:push(MessageState('Cannot run away!', function() end, false))
                        Timer.after(0.5, function() Stack:pop() end)
                    else
                        Stack:pop()
                        Stack:pop()

                        Stack:push(MessageState('Fled successfully!', function() end, false))

                        Timer.after(0.5, function()
                            Stack:push(FadeState(COLORS['black'], 1, 'in', function()
                                Stack:pop()
                                Stack:pop()

                                Stack:push(FadeState(COLORS['black'], 1, 'out', function() end))
                            end))
                        end)
                    end
                end
            }
        }
    }
end

function BattleMenuState:update(dt) self.menu:update(dt) end

function BattleMenuState:render() self.menu:render() end