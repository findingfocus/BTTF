push = require 'push'

Class = require 'class'

require 'Delorean'

require 'StateMachine'

require '/states/BaseState'
require '/states/PlayState'
require '/states/TitleScreenState'
require '/states/WinState'

-- WINDOW SIZE IN REAL PIXELS, EXACTLY DOUBLE THE WORLD
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 750


-- GAME WORLD SIZE IN VIRTUAL PIXELS, PUSH SCALES IT UP
VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 375


background = love.graphics.newImage('graphics/background.png')
backgroundScroll = 0

middle = love.graphics.newImage('graphics/middle.png')
middleScroll = 0

front = love.graphics.newImage('graphics/front.png')
frontScroll = 0

BACKGROUND_SCROLL_SPEED = 0
MIDDLE_SCROLL_SPEED = 0
FRONT_SCROLL_SPEED = 0

LOOPING_POINT = 1000

-- 88MPH TIME TRIAL STATE, RESET EVERY RUN
-- GAMESPEED DRIVES THE SPEEDOMETER, THE SCROLLING, AND THE OBSTACLES
gameSpeed = 0
obstacles = {}
spawnTimer = 0

delorean = Delorean()



function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('BTTF')

	normalFont = love.graphics.newFont('BTTF.ttf', 30)
	smallFont = love.graphics.newFont('BTTF.ttf', 10)
	love.graphics.setFont(normalFont)

	sounds = {
		['titleMusic'] = love.audio.newSource('sounds/MartysLetter.mp3', 'static'),
		['playMusic'] = love.audio.newSource('sounds/Gigawatts.mp3', 'static'),
		['crash'] = love.audio.newSource('sounds/crash.mp3', 'static'),
		['seriousStuff'] = love.audio.newSource('sounds/seriousStuff.mp3', 'static')
	}

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = false,
		highdpi = false
	})

	gStateMachine = StateMachine {
		['title'] = function() return TitleScreenState() end,
		['play'] = function() return PlayState() end,
		['win'] = function() return WinState() end
	}
	gStateMachine:change('title')

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

	gStateMachine:update(dt)
	delorean:update(dt)

	love.keyboard.keysPressed = {} 
end






function love.draw()
	push:start()

	gStateMachine:render()

	push:finish()
end
