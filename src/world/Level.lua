Level = Class()

function Level:init()
    self.mapWidth = 50
    self.mapHeight = 50

    self.groundLayer = TileMap(self.mapWidth, self.mapHeight)
    self.grassLayer = TileMap(self.mapWidth, self.mapHeight)

    self:createMaps()

    self.player = Player {
        animations = ENTITY_DATA['player'].animations,
        mapX = 1,
        mapY = 2,
        width = 32,
        height = 32,
        offsetX = 7,
        offsetY = 8,
        scaleX = 0.5,
        scaleY = 0.5,
        stateMachine = StateMachine {
            ['walk'] = function() return PlayerWalkState(self.player, self) end,
            ['idle'] = function() return PlayerIdleState(self.player) end
        }
    }
    self.player:changeState('idle')
end

function Level:createMaps()
    for y = 1, self.mapWidth do
        table.insert(self.groundLayer.tiles, {})

        for x = 1, self.mapHeight do
            local id = TILES['ground']
            table.insert(self.groundLayer.tiles[y], Tile(x, y, id))
        end
    end

    for y = 1, self.mapWidth do
        table.insert(self.grassLayer.tiles, {})

        for x = 1, self.mapHeight do
            local id = y >= 10 and TILES['grass'] or TILES['empty']
            table.insert(self.grassLayer.tiles[y], Tile(x, y, id)) 
        end
    end
end

function Level:update(dt)
    self.player:update(dt)
end

function Level:render()
    self.groundLayer:render()
    self.grassLayer:render()
    self.player:render()
end