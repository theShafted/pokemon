Menu = Class()

function Menu:init(parameters)
    self.panels = {}
    self.selections = Selections {
        callback = parameters.callback,
        items = parameters.items,
        x = parameters.x,
        y = parameters.y,
        width = parameters.width,
        height = parameters.height,
        orientation = parameters.orientation,
        cursor = parameters.cursor,
        font = parameters.font
    }

    for i = 1, #parameters.items do
        local x, y = self.selections.x, self.selections.y
        local width = math.floor(self.selections.width / #parameters.items)
        local height = math.floor(self.selections.height / #parameters.items)

        if parameters.orientation == 'horizontal' then
            table.insert(self.panels, Panel(x + (i - 1) * width, y, width - 1, self.selections.height))
        else
            table.insert(self.panels, Panel(x, y + (i - 1) * height, self.selections.width, height - 1))
        end
    end
end

function Menu:update(dt) self.selections:update(dt) end

function Menu:render()
    for _, panel in pairs(self.panels) do panel:render() end
    self.selections:render()
end