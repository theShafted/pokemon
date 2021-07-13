Selections = Class()

function Selections:init(parameters)
    self.callback = parameters.callback
    self.items = parameters.items
    self.x = parameters.x 
    self.y = parameters.y 
    self.width = parameters.width
    self.height = parameters.height
    self.font = parameters.font or Fonts['small']

    self.gap = math.floor(self.width / #self.items)
    self.current = 1
end

function Selections:update(dt)
    if love.keyboard.keypressed('left') then
        self.current = self.current == 1 and #self.items or self.current - 1
    elseif love.keyboard.keypressed('right') then
        self.current = self.current == #self.items and 1 or self.current + 1
    elseif love.keyboard.keypressed('space') then
        self.items[self.current]:selected()
        self.callback()
    end
end

function Selections:render()
    love.graphics.setFont(self.font)

    for i = 1, #self.items do 
        local x = self.x + (i - 1) * self.gap
        love.graphics.printf(self.items[i].text, x, self.y + self.height/2 - 6, self.gap, 'center')
    end

    love.graphics.draw(Textures['cursor'], self.x + (self.current - 1) * self.gap, self.y - 10)
end