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
        Stack:push(MessageState(self.pokemon.name .. ' wants to learn ' .. self.move.name, function()
            Stack:pop()

            local message = 'But, it already knows four moves, should one be deleted?'
            Stack:push(MessageState(message, function()
                Stack:push(BattleMenuState(nil, {
                    {
                        text = 'Yes',
                        selected = function()
                            Stack:pop()
                            Stack:pop()

                            Stack:push(MessageState('Which move should be forgotten?', function()
                                Stack:push(BattleMenuState(nil, self.pokemon:getMoves(), function()
                                    Stack:pop()

                                    local index = invert(self.pokemon.learned)[self.pokemon.move]
                                    local name = self.pokemon.move.name
                                    Stack:push(MessageState('Forgot ' .. name .. '!', function()
                                        Stack:pop()

                                        table.remove(self.pokemon.learned, index)
                                        self.pokemon:learn(self.move)

                                        message ='Successfully learned ' .. self.move.name .. '!'
                                        Stack:push(MessageState(message, function()
                                            self.callback()
                                        end))
                                    end))
                                end))
                            end, false))
                        end
                    },
                    {
                        text = 'NO',
                        selected = function()
                            Stack:pop()
                            Stack:pop()
                            Stack:push(MessageState('Did not learn ' .. self.move.name, function()
                                self.callback()
                            end))
                        end
                    }
                }))
            end, false))
        end))
    end
end