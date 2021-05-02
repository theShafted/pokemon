Animation = Class()

function Animation:init(parameters)
    self.frames = parameters.frames
    self.interval = parameters.interval
    self.texture = parameters.texture
    self.looping = parameters.looping or true

    self.timer = 0
    self.currentFrame = 1

    self.timesPlayed = 0
end

function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:update(dt)
    if not self.looping and self.timesPlayed > 0 then return end

    if #self.frames > 1 then
        self.timer = self.timer + dt

        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))

            if self.currentFrame == 1 then self.timesPlayed = self.timesPlayed + 1 end
        end
    end
end

function Animation:getCurrentFrame() return self.frames[self.currentFrame] end