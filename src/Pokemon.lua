Pokemon = Class()

function Pokemon:init(parameters, level)
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

    self:calculateStats()

    self.currentHP = self.HP
end

function Pokemon:getRandom(level)
    return Pokemon(POKEMON_DATA[POKEMON_IDS[math.random(#POKEMON_IDS)]], level or math.random(4))
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

    if self.level >= self.evolveLv then
        return self:evolve(POKEMON_DATA[self.evolveID])
    end

    return self:lvlUpStats()
end

function Pokemon:evolve(evolution)
    self:init(evolution, self.level)

    -- prototype
    --[[self.name = evolution.name
    self.battleFrontSprite = evolution.battleFrontSprite
    self.battleBackSprite = evolution.battleBackSprite
    
    self.baseHP = evolution.baseHP
    self.baseAttack = evolution.baseAttack
    self.baseDefense = evolution.baseDefense
    self.baseSpeed = evolution.baseSpeed

    self.HPIV = evolution.HPIV
    self.attackIV = evolution.attackIV
    self.defenseIV = evolution.defenseIV
    self.speedIV = evolution.speedIV

    self.evolveLv = evolution.evolveLv
    self.evolveID = evolution.evolveID

    self.HP = evolution.baseHP
    self.attack = evolution.baseAttack
    self.defense = evolution.baseDefense
    self.speed = evolution.baseSpeed

    self:calculateStats()

    self.currentHP = self.HP]]
end