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
-- WHICH SCREEN IS SHOWING: TITLE, PLAY, OR WIN
gameState = 'title'
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
		['titleMusic'] = love.audio.newSource('sounds/MartysLetter.mp3', 'stream'),
		['playMusic'] = love.audio.newSource('sounds/Gigawatts.mp3', 'stream'),
		['crash'] = love.audio.newSource('sounds/crash.mp3', 'static'),
		['seriousStuff'] = love.audio.newSource('sounds/seriousStuff.mp3', 'static')
	}

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
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
	elseif love.keyboard.virtualKeysPressed and love.keyboard.virtualKeysPressed[key] then
		return true
	else
		return false
	end
end

-- TOUCH AND MOUSE ZONES: LEFT HALF OF THE SCREEN FLIES, RIGHT HALF ACCELERATES
-- MOUSE USES THE SAME ZONES SO PHONE CONTROLS CAN BE TESTED ON DESKTOP
-- PHONES SEND BOTH TOUCH AND FAKE MOUSE EVENTS FOR ONE TAP
-- ONCE A REAL TOUCH ARRIVES, IGNORE THE MOUSE SO TAPS NEVER DOUBLE FIRE
local touchScreenSeen = false

function love.mousepressed(touchX, touchY, button)
	if touchScreenSeen then return end
	handleTouchZone(touchX, true)
end

function love.mousereleased(touchX, touchY, button)
	if touchScreenSeen then return end
	handleTouchZone(touchX, false)
end

function love.touchpressed(touchId, touchX, touchY)
	touchScreenSeen = true
	handleTouchZone(touchX, true)
end

function love.touchreleased(touchId, touchX, touchY)
	handleTouchZone(touchX, false)
end

function handleTouchZone(touchX, isPressed)
	local gameX = push:toGame(touchX, 0)
	if not gameX then return end

	love.keyboard.virtualKeysDown = love.keyboard.virtualKeysDown or {}
	love.keyboard.virtualKeysPressed = love.keyboard.virtualKeysPressed or {}

	-- TITLE AND WIN SCREENS: ANY TAP IS THE ACTION BUTTON
	if gameState ~= 'play' then
		if isPressed then love.keyboard.virtualKeysPressed['space'] = true end
		return
	end

	-- PLAY: LEFT HALF TAPS FLY, RIGHT HALF HELD ACCELERATES
	if isPressed and gameX < VIRTUAL_WIDTH / 2 then
		love.keyboard.virtualKeysPressed['space'] = true
	elseif gameX >= VIRTUAL_WIDTH / 2 then
		love.keyboard.virtualKeysDown['right'] = isPressed
	end
end

-- HELD KEYS ALSO INCLUDE TOUCH AND MOUSE ZONES
local originalKeyboardIsDown = love.keyboard.isDown
function love.keyboard.isDown(...)
	for keyIndex, key in ipairs({...}) do
		if love.keyboard.virtualKeysDown and love.keyboard.virtualKeysDown[key] then
			return true
		end
	end
	return originalKeyboardIsDown(...)
end





function love.update(dt)

	gStateMachine:update(dt)
	delorean:update(dt)

	love.keyboard.keysPressed = {}
	love.keyboard.virtualKeysPressed = {}
end






function love.draw()
	push:start()

	gStateMachine:render()

	push:finish()
end
