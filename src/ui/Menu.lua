Menu = Class()

function Menu:init(parameters)
    self.panels = {}
    self.selections = Selections {
        items = parameters.items,
        x = parameters.x,
        y = parameters.y,
        width = parameters.width,
        height = parameters.height
    }

    for i = 1, #parameters.items do
        local x, y = parameters.x, parameters.y
        local width = math.floor(parameters.width / #parameters.items)

        table.insert(self.panels, Panel(x + (i - 1) * width, y, width - 1, parameters.height))
    end
end

function Menu:update(dt) self.selections:update(dt) end

function Menu:render()
    for _, panel in pairs(self.panels) do panel:render() end
    self.selections:render()
end