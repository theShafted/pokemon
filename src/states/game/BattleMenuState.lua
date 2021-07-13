BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState, items, callback)
    self.battleState = battleState or nil
    self.callback = callback or function() end

    self.menu = Menu {
        callback = self.callback,
        items = items or {
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