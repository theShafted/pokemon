BattleSprite = Class()

function BattleSprite:init(texture, x, y)
    self.texture = texture
    self.x = x
    self.y = y

    self.opacity = 1
    self.blink = false
    self.whiteShader = love.graphics.newShader[[
        extern float WhiteFactor;

        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb += vec3(WhiteFactor);
            return outputcolor;
        }
    ]]
end

function BattleSprite:update(dt) end

function BattleSprite:render()
    love.graphics.setColor(1, 1, 1, self.opacity)

    love.graphics.setShader(self.whiteShader)
    self.whiteShader:send('WhiteFactor', self.blink and 1 or 0)

    love.graphics.draw(Textures[self.texture], self.x, self.y)

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
end