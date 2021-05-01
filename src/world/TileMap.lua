-- Initiate the Tile Map as a class
TileMap = Class()

-- Constructor function for the Tile Map class taking in its width and height as parameters
function TileMap:init(width, height)

    -- Empty table later to be populated with tiles
    self.tiles = {}

    -- Store the map dimensions
    self.width = width
    self.height = height
end

-- Render method to draw map onto the screen
function TileMap:render()

    -- Iterate through all rows in the map
    for y = 1, self.height do

        -- Iterate through all columns in the row
        for x = 1, self.width do

            -- Call the render method of each tile
            self.tiles[y][x]:render()
        end
    end
end