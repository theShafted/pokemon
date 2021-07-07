Panel = Class()

function Panel:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.color = color or COLORS['panel']

    self.visible = true
end

function Panel:update(dt) end

function Panel:render()
    if self.visible then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 5)
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
        love.graphics.rectangle('fill', self.x + 2, self.y + 2, self.width - 4, self.height - 4, 5)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Panel:toggle()
    self.visible = not self.visible
end