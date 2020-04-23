TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()

end

function TitleScreenState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end
end


function TitleScreenState:render()
	love.graphics.printf('Back to the Future', 0, 20, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('the game', 0, 55, VIRTUAL_WIDTH, 'center')
end