LearnState = Class{__includes = BaseState}

function LearnState:init(pokemon, move, callback)
    self.pokemon = pokemon
    self.move = MOVES_DATA[move]
    self.callback = callback or function() end
end

function LearnState:enter()
    if #self.pokemon.learned < 4 then
        Stack:push(MessageState(self.pokemon.name .. ' learned ' .. self.move.name, function()
            Stack:pop()
            self.pokemon:learn(self.move)
            self.callback()
        end))
    else
        local message = self.pokemon.name .. ' wants to learn ' .. self.move.name
        Stack:push(message, function()
            message = 'But, it already knows four moves, should one be deleted?'
            Stack:push(message, function()
                Stack:push(BattleMenuState(nil, {
                    {
                        text = 'Yes',
                        selected = function()
                            Stack:pop()

                            Stack:push('Which move should be forgotten?', function()
                                Stack:push(BattleMenuState(nil, self.pokemon:getMoves(), function()
                                    Stack:pop()
                                    table.remove(self.pokemon.learned, invert(self.pokemon.move))

                                    Stack:push(MessageState('Forgot', function()
                                        Stack:pop()
                                        self.pokemon:learn(self.move)
                                        Stack:push('Successfully learned ' .. self.move.name)
                                    end))
                                end))
                            end)
                        end
                    },
                    {
                        text = 'NO',
                        selected = function()
                            Stack:pop()
                            Stack:push(MessageState('Did not learn ' .. self.move.name))
                        end
                    }
                }))
            end)
        end)
    end
end