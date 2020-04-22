Player = Class{}

function Player:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height =  height
end

--[[
function Player1:collides(player2)
	if Player1.x > Player2.x + Player2.width or Player2.x > Player1.x + Player2.width then
		return false
	end

	if Player1.y > Player2.y + Player2.height or Player2.y > Player1.y + Player1.height then
		return false
	end
		
	return true
end

function Player1:reset()
	Player1.x =
	Player1.y = 
--]]