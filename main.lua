push = require 'push'

Class = require 'class'

require 'Delorean'

require 'Player'

--1280 800
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 800


--600 375
VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 375


local background = love.graphics.newImage('graphics/background.png')
local backgroundScroll = 0

local middle = love.graphics.newImage('graphics/middle.png')
local middleScroll = 0

local front = love.graphics.newImage('graphics/front.png')
local frontScroll = 0

local delorean = Delorean()

local BACKGROUND_SCROLL_SPEED = 0
local MIDDLE_SCROLL_SPEED = 0
local FRONT_SCROLL_SPEED = 0

LOOPING_POINT = 1000

delorean = Delorean()





function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('BTTF')

	normalFont = love.graphics.newFont('BTTF.ttf', 30)
	love.graphics.setFont(normalFont)

	sounds = {
		['titleMusic'] = love.audio.newSource('music/MartysLetter.mp3', 'static'),
		['playMusic'] = love.audio.newSource('music/Gigawatts.mp3', 'static')
	}

	sounds['playMusic']:setLooping(true)
	sounds['playMusic']:play()

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = true
	})

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
	push:resize(w,h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end





function love.update(dt)
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		% LOOPING_POINT

	middleScroll = (middleScroll + MIDDLE_SCROLL_SPEED * dt)
		% LOOPING_POINT

	frontScroll = (frontScroll + FRONT_SCROLL_SPEED * dt)
		% LOOPING_POINT

	if love.keyboard.isDown('right') then
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
	delorean:update(dt)

	love.keyboard.keysPressed = {} 
end






function love.draw()
	push:start()

	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(middle, -middleScroll, 0)
	love.graphics.draw(front, -frontScroll, 0)
	delorean:render()

	love.graphics.printf('Back to the Future', 0, 20, VIRTUAL_WIDTH, 'center')
	--love.graphics.printf('the game', 0, 55, VIRTUAL_WIDTH, 'center')

	push:finish()
end