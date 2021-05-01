Tile = Class()

function Tile:init(x, y, id)
    self.x = x
    self.y = y
    self.id = id
end

function Tile:render()
    love.graphics.draw(Textures['tiles'], Frames['tiles'][self.id],
        (self.x - 1) * TILE_SIZE/2, (self.y - 1) * TILE_SIZE/2,
        0, 0.5, 0.5)
end