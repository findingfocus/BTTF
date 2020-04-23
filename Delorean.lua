Delorean = Class{}

local GRAVITY = 10

function Delorean:init()
	self.image = love.graphics.newImage('graphics/delorean.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = 10
	self.y = VIRTUAL_HEIGHT - 200
	self.dy = 0
end

function Delorean:update(dt)
	self.dy = self.dy + GRAVITY * dt

	if love.keyboard.wasPressed('space') then
		self.dy = - 4
	end
	self.y = self.y + self.dy
	self.y = math.min(VIRTUAL_HEIGHT -110, self.y)
end


function Delorean:render()
	love.graphics.draw(self.image, self.x, self.y)
end