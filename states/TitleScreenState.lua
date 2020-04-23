TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()

end

function TitleScreenState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end

	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED + .5 * dt)
		% LOOPING_POINT

	middleScroll = (middleScroll + MIDDLE_SCROLL_SPEED + 2 * dt)
		% LOOPING_POINT

	frontScroll = (frontScroll + FRONT_SCROLL_SPEED + 15 * dt)
		% LOOPING_POINT
end


function TitleScreenState:render()
	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(middle, -middleScroll, 0)
	love.graphics.draw(front, -frontScroll, 0)
	love.graphics.setFont(normalFont)
	love.graphics.printf('Back to the Future', 0, 30, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('the game', 0, 65, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('press enter to start', 0 , VIRTUAL_HEIGHT/ 2, VIRTUAL_WIDTH, 'center')

end