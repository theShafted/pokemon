function generateQuads(sheet, width, height)
    local sheetWidth = sheet:getWidth() / width
    local sheetHeight = sheet:getHeight() / height

    local counter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[counter] = love.graphics.newQuad(x * width, y * height, width, height,
                sheet:getDimensions())
            counter = counter + 1
        end
    end

    return spritesheet
end

function invert(t)
    local s = {}
    for k, v in pairs(t) do s[v]=k end
    
    return s
 end