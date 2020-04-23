Delorean = Class{}

local GRAVITY = 10

local grounded = true

function Delorean:init()
	self.image = love.graphics.newImage('graphics/delorean.png')
	self.fly = love.graphics.newImage('graphics/deloreanfly.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = 10
	self.y = 375 - 110
	self.dy = 0
end

function Delorean:update(dt)
	self.dy = self.dy + GRAVITY * dt

	--currently limits jumps, but this will probably be used for switching delorean pics
	if self.y == 265 then
		grounded = true
	else
		grounded = false
	end

	--if grounded then
	if love.keyboard.wasPressed('space') then
		self.dy = - 4
	end

	self.y = self.y + self.dy
	self.y = math.min(VIRTUAL_HEIGHT -110, self.y)
end


function Delorean:render()
	if grounded then
		love.graphics.draw(self.image, self.x, self.y)
	elseif not grounded then
		love.graphics.draw(self.fly, self.x, self.y)
	end
end