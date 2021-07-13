Menu = Class()

function Menu:init(parameters)
    self.panels = {}
    self.selections = Selections {
        callback = parameters.callback,
        items = parameters.items,
        x = parameters.x or 150,
        y = parameters.y or GAME_HEIGHT - 68,
        width = parameters.width or GAME_WIDTH - 150,
        height = parameters.height or 17
    }

    for i = 1, #parameters.items do
        local x, y = self.selections.x, self.selections.y
        local width = math.floor(self.selections.width / #parameters.items)

        table.insert(self.panels, Panel(x + (i - 1) * width, y, width - 1, self.selections.height))
    end
end

function Menu:update(dt) self.selections:update(dt) end

function Menu:render()
    for _, panel in pairs(self.panels) do panel:render() end
    self.selections:render()
end