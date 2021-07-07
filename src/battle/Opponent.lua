Opponent = Class()

function Opponent:init(parameters)
    self.party = parameters.party
    self.items = parameters.items
    self.wild = parameters.wild
    self.name = self.wild and parameters.name or nil
end