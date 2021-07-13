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
end

function Pokemon:getRandom(level)
    return Pokemon(POKEMON_DATA[POKEMON_IDS[math.random(#POKEMON_IDS)]], level or math.random(2, 4))
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

function Pokemon:getMoves()
    local moves = {}
    
    for _, move in pairs(self.learned) do
        table.insert(moves, {
            text = move.name,
            selected = function()
                self.move = move
            end
        })
    end
   
    return moves
end

function Pokemon:learn(move)
    if move then
        table.insert(self.learned, move)
        return
    end
        
    for name, level in pairs(self.moves) do
        local move = MOVES_DATA[name]
        if level <= self.level then self:learn(move) end
    end
end