BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState)
    self.battleState = battleState

    self.menu = Menu {
        x = 150,
        y = GAME_HEIGHT - 68,
        width = GAME_WIDTH - 150,
        height = 17,
        items = {
            {
                text = "ATTACK",
                selected = function() end
            },
            {
                text = "RUN",
                selected = function() end
            },
            {
                text = "POKEMON",
                selected = function() end
            },
            {
                text = "BAG",
                selected = function() end
            }
        }
    }
end

function BattleMenuState:update(dt) self.menu:update(dt) end

function BattleMenuState:render() self.menu:render() end