Selections = Class()

function Selections:init(parameters)
    self.callback = parameters.callback
    self.items = parameters.items
    self.x = parameters.x 
    self.y = parameters.y 
    self.width = parameters.width
    self.height = parameters.height
    self.font = parameters.font or Fonts['small']

    self.orientation = parameters.orientation

    self.gap = self.orientation == 'horizontal' and self.width/#self.items or self.height/#self.items
    self.gap = math.floor(self.gap)

    self.current = 1

    self.cursor = parameters.cursor == nil and true or parameters.cursor
end

function Selections:update(dt)
    if love.keyboard.keypressed('left') and self.cursor then
        self.current = self.current == 1 and #self.items or self.current - 1
    elseif love.keyboard.keypressed('right') and self.cursor then
        self.current = self.current == #self.items and 1 or self.current + 1
    elseif love.keyboard.keypressed('space') then
        if self.cursor then
            self.items[self.current]:selected()
            self.callback()
        else
            self.items[1]:selected()
        end
    end
end

function Selections:render()
    love.graphics.setFont(self.font)

    for i = 1, #self.items do 
        local x = self.x + (i - 1) * self.gap
        local y = self.y + (i - 1) * self.gap
        
        if self.orientation == 'horizontal' then
            love.graphics.printf(self.items[i].text, x, self.y + self.height/2 - 6, self.gap, 'center')
        else
            love.graphics.printf(self.items[i].text, self.x, y + self.gap/2 - 6, self.width, 'center')
        end
    end

    if self.cursor then
        love.graphics.draw(Textures['cursor'], self.x + (self.current - 1) * self.gap, self.y - 10)
    end
end