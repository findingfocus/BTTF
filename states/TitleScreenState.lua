TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()

end

function TitleScreenState:enter()
	-- CLEAN SLATE SO REPLAYS ALWAYS START THE SAME
	gameState = 'title'
	gameSpeed = 0
	obstacles = {}
	spawnTimer = 1.5
	BACKGROUND_SCROLL_SPEED = 0
	MIDDLE_SCROLL_SPEED = 0
	FRONT_SCROLL_SPEED = 0
end

function TitleScreenState:update(dt)
	sounds['titleMusic']:setLooping(true)
	sounds['titleMusic']:play()
	
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
		sounds['titleMusic']:stop()
		gStateMachine:change('play')
	end

	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED + 1 * dt)
		% LOOPING_POINT

	middleScroll = (middleScroll + MIDDLE_SCROLL_SPEED + 2 * dt)
		% LOOPING_POINT

	frontScroll = (frontScroll + FRONT_SCROLL_SPEED + 18 * dt)
		% LOOPING_POINT
end


function TitleScreenState:render()
	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(middle, -middleScroll, 0)
	love.graphics.draw(front, -frontScroll, 0)
	love.graphics.setFont(normalFont)
	love.graphics.printf('Back to the Future', 0, 30, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('press enter to start', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

end