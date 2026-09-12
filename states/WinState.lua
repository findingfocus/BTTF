WinState = Class{__includes = BaseState}

-- WIN SCREEN, ENTER DRIVES AGAIN

function WinState:init()

end

function WinState:enter()
	-- REMEMBER WHICH SCREEN IS SHOWING FOR TOUCH ZONES
	gameState = 'win'
	sounds['seriousStuff']:play()
end

function WinState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
		gStateMachine:change('play')
	elseif love.keyboard.wasPressed('t') then
		gStateMachine:change('title')
	end
end


function WinState:render()
	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(middle, -middleScroll, 0)
	love.graphics.draw(front, -frontScroll, 0)
	love.graphics.setFont(normalFont)
	love.graphics.printf('88 MPH!', 0, 30, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('TIME TRAVEL ACHIEVED', 0, 70, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('press enter to play again', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
