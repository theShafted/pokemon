Bar = Class()

function Bar:init(parameters)
    self.x = parameters.x
    self.y = parameters.y
    self.width = parameters.width
    self.height = parameters.height

    self.color = parameters.color 
    self.max = parameters.max
    self.value = parameters.value
end

function Bar:setMax(max) self.max = self.max end

function Bar:setValue(value) self.value = value end

function Bar:update(dt) end

function Bar:render()
    local remaining = math.floor(self.value / self.max * self.width)
    
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)

    if self.value > 0 then
        love.graphics.rectangle('fill', self.x, self.y, remaining, self.height, 1)
    end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 1)
    love.graphics.setColor(1, 1, 1, 1)
end