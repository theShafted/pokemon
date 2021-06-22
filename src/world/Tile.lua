Tile = Class()

function Tile:init(x, y, id)
    self.offsetX = 0
    self.offsetY = 6

    self.x = (x - 1) * TILE_SIZE/2 - self.offsetX
    self.y = (y - 1) * TILE_SIZE/2 - self.offsetY
    self.id = id
end

function Tile:update(dt)

end

function Tile:checkCollisions(entity)
    return entity.x + entity.width >= self.x and
        entity.y + entity.height >= self.y

end

function Tile:render()
    love.graphics.draw(Textures['tiles'], Frames['tiles'][self.id],
        math.floor(self.x), math.floor(self.y),
        0, 0.5, 0.5)
end