Pokemon = Class()

function Pokemon:init(parameters, level, learned)
    self.name = parameters.name
    self.frontSprite = parameters.frontSprite
    self.backSprite = parameters.backSprite
    
    self.baseHP = parameters.baseHP
    self.baseAttack = parameters.baseAttack
    self.baseDefense = parameters.baseDefense
    self.baseSpeed = parameters.baseSpeed

    self.HPIV = parameters.HPIV
    self.attackIV = parameters.attackIV
    self.defenseIV = parameters.defenseIV
    self.speedIV = parameters.speedIV

    self.evolveLv = parameters.evolveLv
    self.evolveID = parameters.evolveID

    self.level = level
    self.exp = 0
    self.lvlUpExp = self.level * self.level * 5 * 0.75

    self.HP = parameters.baseHP
    self.attack = parameters.baseAttack
    self.defense = parameters.baseDefense
    self.speed = parameters.baseSpeed

    self.currentHP = self.HP

    self.moves = parameters.moves
    self.learned = {}

    self:calculateStats()
    self:learn()

    self.learned = learned or self.learned
    self.move = self.learned[#self.learned]

    self.modifiers = {
        attack = 0,
        defense = 0,
        speed = 0,
        critical = 6.25/100
    }

    self.isCritical = false
end

function Pokemon:getRandom(level)
    local level = level or math.random(2, 4)
    return Pokemon(POKEMON_DATA[POKEMON_IDS[math.random(#POKEMON_IDS)]], level)
end

function Pokemon:calculateStats()
    for i = 1, self.level do
        self:lvlUpStats()
    end
end

function Pokemon:lvlUpStats()
    local HP, attack, defense, speed = 0, 0, 0, 0

    for i = 1, 3 do
        if math.random(6) <= self.HPIV then
            self.HP = self.HP + 1
            self.currentHP = self.currentHP + 1
            HP = HP + 1
        end

        if math.random(6) <= self.attackIV then
            self.attack = self.attack + 1
            attack = attack + 1
        end

        if math.random(6) <= self.defenseIV then
            self.defense = self.defense + 1
            defense = defense + 1
        end

        if math.random(6) <= self.speed then
            self.speed = self.speed + 1
            speed = speed + 1
        end
    end

    return HP, attack, defense, speed
end

function Pokemon:levelUp()
    self.level = self.level + 1
    self.lvlUpExp = self.level * self.level * 5 * 0.75

    return self:lvlUpStats()
end

function Pokemon:evolve()
    self:init(POKEMON_DATA[self.evolveID], self.level, self.learned)
end

function Pokemon:getMoves(callback)
    local moves = {}
    
    for _, move in ipairs(self.learned) do
        table.insert(moves, {
            text = move.name,
            selected = callback or function() self.move = move end
        })
    end
   
    return moves
end

function Pokemon:learn(move)
    if move then
        table.insert(self.learned, move)
        return
    end
        
    for i = 1, 100 do
        for name, level in pairs(self.moves) do
            if level == i then
                if level <= self.level then self:learn(MOVES_DATA[name]) end
            end
        end
    end
end

function Pokemon:getExp(pokemon)
    return pokemon.level * (pokemon.HPIV + pokemon.attackIV + pokemon.defenseIV + pokemon.speedIV)
end

function Pokemon:getDamage(move, pokemon)
    move.effect(self, pokemon)

    local modifier = MODIFIERS[self.modifiers.attack]
    local random = math.random(3)

    if move.type == 'damage' then
        self.isCritical = math.random() <= self.modifiers.critical and true or false

        if self.isCritical then
            modifier = self.modifiers.attack > 0 and modifier or MODIFIERS[0]
            modifier = pokemon.modifiers.defense > 0 and 2 * modifier or 2 * modifier / MODIFIERS[pokemon.modifiers.defense]

            Stack:push(MessageState('It\'s a critical hit!', nil, false))
        else 
            modifier = modifier / MODIFIERS[pokemon.modifiers.defense]
        end

        return math.max(1, math.floor(move.power * modifier * self.attack/pokemon.defense) + random)
    else
        return 0
    end
end

function Pokemon:resetModifiers()
    self.modifiers = {
        attack = 0,
        defense = 0,
        speed = 0,
        critical = 6.25
    }

    self.isCritical = false
end