-- Imported external libraries 
Push = require 'libs/push'
Timer = require 'libs/timer'
Class = require 'libs/class'
Easing = require 'libs/easing'

-- Imported document classes
require 'src/constants'
require 'src/utility'
require 'src/StateStack'
require 'src/StateMachine'
require 'src/Animation'

require 'src/pokemon_data'
require 'src/Pokemon'

require 'src/ui/Panel'
require 'src/ui/Bar'

require 'src/battle/BattleSprite'
require 'src/battle/Opponent'

require 'src/entity/entity_data'
require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/world/Tile'
require 'src/world/TileMap'
require 'src/world/Level'

-- Imported game state classes
require 'src/states/game/BaseState'
require 'src/states/game/FadeState'
require 'src/states/game/TitleState'
require 'src/states/game/PlayState'
require 'src/states/game/BattleState'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

-- Imported fonts
Fonts =
{
    ['title'] = love.graphics.newFont('fonts/8bit.ttf', FONTS['title']),
    ['small'] = love.graphics.newFont('fonts/8bit.ttf', FONTS['small'])
}

-- Imported textures
Textures = {
    -- Tileset texture
    ['tiles'] = love.graphics.newImage('graphics/tileset.png'),

    -- Particle texture
    ['particle'] = love.graphics.newImage('graphics/particle.png'),
    
    -- Pokemon sprite textures (front and back sprites)
    ['flambear-front'] = love.graphics.newImage('graphics/Flambear.png'),
    ['flambear-back'] = love.graphics.newImage('graphics/Flambear_back.png'),
    ['viviteel-front'] = love.graphics.newImage('graphics/Viviteel.png'),
    ['viviteel-back'] = love.graphics.newImage('graphics/Viviteel_back.png'),
    ['pipis-front'] = love.graphics.newImage('graphics/Pipis.png'),
    ['pipis-back'] = love.graphics.newImage('graphics/Pipis_back.png'),
    ['rockitten-front'] = love.graphics.newImage('graphics/Rockitten.png'),
    ['rockitten-back'] = love.graphics.newImage('graphics/Rockitten_back.png'),
    ['rockat-front'] = love.graphics.newImage('graphics/Rockat.png'),
    ['rockat-back'] = love.graphics.newImage('graphics/Rockat_back.png'),
    ['criniotherme-front'] = love.graphics.newImage('graphics/Criniotherme.png'),
    ['criniotherme-back'] = love.graphics.newImage('graphics/Criniotherme_back.png'),

    ['player'] = love.graphics.newImage('graphics/player.png');
}

Frames = {
    ['tiles'] = generateQuads(Textures['tiles'], TILE_SIZE, TILE_SIZE),
    ['player'] = generateQuads(Textures['player'], 64, 64)
}