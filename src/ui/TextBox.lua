TextBox = Class()

function TextBox:init(x, y, width, height, message, font)
    self.panel = Panel(x, y, width, height, COLORS['panel'])

    self.x = x
    self.y = y 
    self.width = width
    self.height = height
    self.font = font or Fonts['small']

    self.message = message
    _, self.wrappedMessage = self.font:getWrap(self.message, self.width - 10)

    self.counter = 1
    self.messageEnd = false
    self.closed = false

    self.displayedText = {}
    self:next()
end

function TextBox:nextPage()
    local page = {}

    for i = self.counter, self.counter + 2 do
        table.insert(page, self.wrappedMessage[i])

        if i == #self.wrappedMessage then
            self.messageEnd = true
            return page
        end
    end

    self.counter = self.counter + 3
    return page
end

function TextBox:next()
    if self.messageEnd then
        self.displayedText = {}
        self.panel:toggle()
        self.closed = true
    else
        self.displayedText = self:nextPage()
    end
end

function TextBox:update(dt)
    if love.keyboard.keypressed('space') then self:next() end
end

function TextBox:isClosed() return self.closed end

function TextBox:render()
    self.panel:render()

    love.graphics.setFont(self.font)
    for i = 1, #self.displayedText do
        love.graphics.print(self.displayedText[i], self.x + 5, self.y + 5 + (i - 1) * 16)
    end
end