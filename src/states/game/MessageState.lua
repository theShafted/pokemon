MessageState = Class{__includes = BaseState}

function MessageState:init(message, callback, input)
    self.textbox = TextBox(0, GAME_HEIGHT - 50, GAME_WIDTH, 50, message)
    self.callback = callback or function() end
    self.input = input == nil and true or input
end

function MessageState:update(dt)
    if self.input then
        self.textbox:update(dt)

        if self.textbox:isClosed() then
            Stack:pop()
            self.callback()
        end
    else self.callback() end
end

function MessageState:render() self.textbox:render() end