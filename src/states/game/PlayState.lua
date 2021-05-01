PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.level = Level()
end

function PlayState:update(dt) 

end

function PlayState:render()
    self.level:render()
end