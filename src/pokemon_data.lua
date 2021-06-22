-- All pokemon ids
POKEMON_IDS = {'flambear', 'viviteel', 'pipis', 'rockitten', 'rockat', 'criniotherme'}

--[[
    All pokemon stats and definitions in the following format:
    
    Name of the pokemon
    Front facing sprite
    Back facing sprite

    Base HP stat
    Base Attack stat
    Base Defense stat
    Base Speed Stat

    HP IVs
    Attack IVs
    Defense IVs
    Speed IVs

    Level at which the pokemon evolves
    ID of the evolution of the pokemon
]]
POKEMON_DATA =
{
        ['flambear'] =
        {
            name = 'Flambear',
            frontSprite = 'flambear-front',
            backSprite = 'flambear-back',
            
            baseHP = 20,
            baseAttack = 14,
            baseDefense = 12,
            baseSpeed = 4,
            
            HPIV = 4,
            attackIV = 4,
            defenseIV = 4,
            speedIV = 3,

            evolveLv = 101,
            evolveID = ''
        },

        ['viviteel'] =
        {
            name = 'Viviteel',
            frontSprite = 'viviteel-front',
            backSprite = 'viviteel-back',
            
            baseHP = 10,
            baseAttack = 14,
            baseDefense = 13,
            baseSpeed = 13,
            
            HPIV = 1,
            attackIV = 5,
            defenseIV = 4,
            speedIV = 5,

            evolveLv = 101,
            evolveID = ''
        },

        ['pipis'] =
        {
            name = 'Pipis',
            frontSprite = 'pipis-front',
            backSprite = 'pipis-back',
            
            baseHP = 8,
            baseAttack = 17,
            baseDefense = 10,
            baseSpeed = 15,
            
            HPIV = 1,
            attackIV = 5,
            defenseIV = 4,
            speedIV = 5,

            evolveLv = 101,
            evolveID = ''
        },

        ['rockitten'] =
        {
            name = 'Rockitten',
            frontSprite = 'rockitten-front',
            backSprite = 'rockitten-back',
            
            baseHP = 13,
            baseAttack = 5,
            baseDefense = 12,
            baseSpeed = 10,
            
            HPIV = 3,
            attackIV = 1,
            defenseIV = 3,
            speedIV = 3,

            evolveLv = 2,
            evolveID = 'rockat'
        },

        ['rockat'] =
        {
            name = 'Rockat',
            frontSprite = 'rockat-front',
            backSprite = 'rockat-back',
            
            baseHP = 15,
            baseAttack = 12,
            baseDefense = 12,
            baseSpeed = 11,
            
            HPIV = 5,
            attackIV = 4,
            defenseIV = 3,
            speedIV = 3,

            evolveLv = 101,
            evolveID = ''
        },
        
        ['criniotherme'] =
        {
            name = 'Criniotherme',
            frontSprite = 'criniotherme-front',
            backSprite = 'criniotherme-back',
            
            baseHP = 10,
            baseAttack = 20,
            baseDefense = 8,
            baseSpeed = 12,
            
            HPIV = 4,
            attackIV = 5,
            defenseIV = 2,
            speedIV = 4,

            evolveLv = 101,
            evolveID = ''
        },
}