MOVES_IDS = { 'scratch'}

MOVES_DATA = {
    ['scratch'] = 
    {
        name = 'scratch',
        power = 5,
        accuracy = 100,
        type = 'damage',
        effect = function() end
    },
    ['tackle'] =
    {
        name = 'tackle',
        power = 6,
        accuracy = 100,
        type = 'damage',
        effect = function() end
    },
    ['rollout'] = 
    {
        name = 'rollout',
        power = 10,
        accuracy = 90,
        type = 'damage',
        effect = function() end
    },
    ['growl'] = 
    {
        name = 'growl',
        power = 0,
        accuracy = 100,
        type = 'debuff',
        effect = function(player, opponent)
            opponent.modifiers.attack = math.max(-6, opponent.modifiers.attack - 1)
            
            if opponent.modifiers.attack <= -6 then
                Stack:push(MessageState(opponent.name .. '\'s attack won\'t go any lower', nil, false))
            else
                Stack:push(MessageState(opponent.name .. '\'s attack fell!', nil, false))
            end
        end
    },
    ['leer'] = 
    {
        name = 'leer',
        power = 0,
        accuracy = 100,
        type = 'debuff',
        effect = function(player, opponent)
            opponent.modifiers.defense = math.max(-6, opponent.modifiers.defense - 1)

            if opponent.modifiers.defense <= -6 then
                Stack:push(MessageState(opponent.name .. '\'s defense won\'t go any lower', nil, false))
            else
                Stack:push(MessageState(opponent.name .. '\'s defense fell!', nil, false))
            end
        end
    },
    ['shadow-claw'] =
    {
        name = 'shadow claw',
        power = 10,
        accuracy = 100,
        type = 'damage',
        effect = function(player, opponent) player.modifiers.critical = math.min(50, 2 * player.modifiers.critical) end
    },
    ['rock-polish'] = 
    {
        name = 'rock polish',
        power = 0,
        accuracy = 100,
        type = 'buff',
        effect = function(player, opponent)
            player.modifiers.speed = math.min(6, player.modifiers.speed + 1)

            if player.modifiers.speed >= 6 then
                Stack:push(MessageState(player.name .. '\'s speed won\'t go any lower', nil, false))
            else
                Stack:push(MessageState(player.name .. '\'s speed increased!', nil, false))
            end
        end
    }
}