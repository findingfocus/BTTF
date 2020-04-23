PlayState = Class{__includes = BaseState}


delorean = Delorean()

function PlayState:init()
	--empty
end

function PlayState:update(dt)
	sounds['playMusic']:setLooping(true)
	sounds['playMusic']:play()
	--scrolls screen based on input
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		% LOOPING_POINT

	middleScroll = (middleScroll + MIDDLE_SCROLL_SPEED * dt)
		% LOOPING_POINT

	frontScroll = (frontScroll + FRONT_SCROLL_SPEED * dt)
		% LOOPING_POINT
	if love.keyboard.wasPressed('t') then
		gStateMachine:change('title')
	elseif love.keyboard.isDown('right') then
		BACKGROUND_SCROLL_SPEED = BACKGROUND_SCROLL_SPEED + 1 * dt
		MIDDLE_SCROLL_SPEED = MIDDLE_SCROLL_SPEED + 5 * dt
		FRONT_SCROLL_SPEED = FRONT_SCROLL_SPEED + 40 * dt

	elseif BACKGROUND_SCROLL_SPEED > 0 then
		BACKGROUND_SCROLL_SPEED = BACKGROUND_SCROLL_SPEED - 2 * dt
		MIDDLE_SCROLL_SPEED = MIDDLE_SCROLL_SPEED - 10 * dt
		FRONT_SCROLL_SPEED = FRONT_SCROLL_SPEED - 80 * dt

	else
		BACKGROUND_SCROLL_SPEED = BACKGROUND_SCROLL_SPEED * dt
		MIDDLE_SCROLL_SPEED = MIDDLE_SCROLL_SPEED * dt
		FRONT_SCROLL_SPEED = FRONT_SCROLL_SPEED * dt
	end
end

function PlayState:render()
	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(middle, -middleScroll, 0)
	love.graphics.draw(front, -frontScroll, 0)
	delorean:render()
end