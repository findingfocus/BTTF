Delorean = Class{}

function Delorean:init()
	self.image = love.graphics.newImage('graphics/delorean.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = 10
	self.y = VIRTUAL_HEIGHT - 122
end

function update(dt)

end

function Delorean:render()
	love.graphics.draw(self.image, self.x, self.y)
end