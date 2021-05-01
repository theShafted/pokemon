Level = Class()

function Level:init()
    self.mapWidth = 50
    self.mapHeight = 50

    self.groundLayer = TileMap(self.mapWidth, self.mapHeight)
    self.grassLayer = TileMap(self.mapWidth, self.mapHeight)

    self:createMaps()
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

function Level:render()
    self.groundLayer:render()
    self.grassLayer:render()
end