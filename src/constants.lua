-- Font sizes
FONTS = 
{
    ['title'] = 24,
    ['small'] = 6,
    ['tiny'] = 4
}

-- Constants for game and window screen dimensions to be used by push 
GAME_WIDTH = 384
GAME_HEIGHT = 216

WINDOW_WIDTH = 1440
WINDOW_HEIGHT = 1080

-- Color pallettes
COLORS =
{
    ['black'] = {r = 0, g = 0, b = 0},
    ['white'] = {r = 1, g = 1, b = 1},
    
    ['health'] = {r = 32/255, g = 189/255, b = 32/255},
    ['exp'] = {r = 32/255, g = 32/255, b = 189/255},

    ['panel'] = {r = 25/255, g = 25/255, b = 25/255}
}

POKEMON_SPRITE_SIZE = 64
TILE_SIZE = 32

TILES = {
    ['empty'] = 1517,
    ['black'] = 1,
    ['ground'] = 2,
    ['grass'] = 3,

}

PLAYER_WALK_SPEED = 2.5
PLAYER_RUN_SPEED = 6.5

MODIFIERS = {
    [-6] = 0.25,
    [-5] = 0.28,
    [-4] = 0.33,
    [-3] = 0.4,
    [-2] = 0.5,
    [-1] = 0.66,
    [0] = 1,
    [1] = 1.5,
    [2] = 2,
    [3] = 2.5,
    [4] = 3,
    [5] = 3.5,
    [6] = 4
}