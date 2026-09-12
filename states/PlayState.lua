PlayState = Class{__includes = BaseState}


delorean = Delorean()

local WIN_SPEED = 88
-- PUNCHY LAUNCH, LONG GRIND TO 88
-- BUILD RATE SLIDES FROM LAUNCH_RATE AT 0MPH TO CRUISE_RATE AT 88MPH
local LAUNCH_RATE = 12
local CRUISE_RATE = 1.2
local DRAG = 4
local HIT_PENALTY = 15
local SPAWN_GATE = 5
-- WORLD MOTION FOLLOWS THE SPEEDOMETER ON A CURVE
-- ZERO STILL MEANS PARKED
local WORLD_MAX = 560
local WORLD_CURVE = 0.55

function PlayState:init()
end

function PlayState:enter()
	-- FRESH RUN EVERY TIME PLAY STARTS
	gameState = 'play'
	gameSpeed = 0
	obstacles = {}
	spawnTimer = 1.5
	BACKGROUND_SCROLL_SPEED = 0
	MIDDLE_SCROLL_SPEED = 0
	FRONT_SCROLL_SPEED = 0
	delorean = Delorean()
	-- DROP START-UP KEYS SO THEY DO NOT LEAK INTO THE RUN
	love.keyboard.keysPressed = {}
	love.keyboard.virtualKeysPressed = {}
end

local function collides(playerX, playerY, playerWidth, playerHeight, obstacleX, obstacleY, obstacleWidth, obstacleHeight)
	return playerX < obstacleX + obstacleWidth
		and obstacleX < playerX + playerWidth
		and playerY < obstacleY + obstacleHeight
		and obstacleY < playerY + playerHeight
end

local function accelerationRate(currentSpeed)
	return CRUISE_RATE + (LAUNCH_RATE - CRUISE_RATE) * (1 - currentSpeed / WIN_SPEED)
end

local function calculateWorldSpeed(currentSpeed)
	local speedFraction = math.min(1, currentSpeed / WIN_SPEED)
	return WORLD_MAX * (speedFraction ^ WORLD_CURVE)
end

local function spawnObstacle()
	-- BALLS SPAWN NEAR THE CAR SO EVERY RUN STAYS DANGEROUS
	local spawnHeight = delorean.y + (math.random() * 120 - 60)
	spawnHeight = math.max(40, math.min(VIRTUAL_HEIGHT - 40, spawnHeight))
	local radius = 8 + math.random() * 6
	table.insert(obstacles, {
		x = VIRTUAL_WIDTH + 20,
		y = spawnHeight,
		r = radius
	})
end

function PlayState:update(dt)
	sounds['playMusic']:setLooping(true)
	sounds['playMusic']:play()

	if love.keyboard.wasPressed('t') then
		gStateMachine:change('title')
		return
	end

	-- ONE SPEED DRIVES EVERYTHING: HOLD RIGHT TO BUILD IT, LET GO TO COAST DOWN
	if love.keyboard.isDown('right', 'd') then
		gameSpeed = math.min(100, gameSpeed + accelerationRate(gameSpeed) * dt)
	else
		gameSpeed = math.max(0, gameSpeed - DRAG * dt)
	end

	-- PARALLAX SCROLL FOLLOWS THE SPEEDOMETER
	local worldSpeed = calculateWorldSpeed(gameSpeed)
	BACKGROUND_SCROLL_SPEED = worldSpeed * 0.03
	MIDDLE_SCROLL_SPEED = worldSpeed * 0.13
	FRONT_SCROLL_SPEED = worldSpeed

	-- MOVE EACH BACKGROUND LAYER AT ITS OWN SPEED
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		% LOOPING_POINT

	middleScroll = (middleScroll + MIDDLE_SCROLL_SPEED * dt)
		% LOOPING_POINT

	frontScroll = (frontScroll + FRONT_SCROLL_SPEED * dt)
		% LOOPING_POINT

	-- SPARSE OBSTACLES ONLY WHILE DRIVING
	-- A PARKED CAR SPAWNS NOTHING
	if gameSpeed > SPAWN_GATE then
		spawnTimer = spawnTimer - dt
		if spawnTimer <= 0 then
			spawnObstacle()
			spawnTimer = math.max(1.5, 3.0 - gameSpeed / 80)
		end
	end

	-- OBSTACLES APPROACH AT WORLD SPEED
	-- PARKED CAR MEANS A FROZEN ROAD
	for i = #obstacles, 1, -1 do
		local obstacle = obstacles[i]
		obstacle.x = obstacle.x - worldSpeed * dt
		if obstacle.x < -30 then
			table.remove(obstacles, i)
		elseif collides(delorean.x, delorean.y, delorean.width, delorean.height,
			obstacle.x - obstacle.r, obstacle.y - obstacle.r, obstacle.r * 2, obstacle.r * 2) then
			gameSpeed = math.max(0, gameSpeed - HIT_PENALTY)
			sounds['crash']:play()
			table.remove(obstacles, i)
		end
	end

	-- 88MPH: TIME TRAVEL ACHIEVED
	if gameSpeed >= WIN_SPEED then
		sounds['playMusic']:stop()
		gStateMachine:change('win')
	end
end

function PlayState:render()
	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(middle, -middleScroll, 0)
	love.graphics.draw(front, -frontScroll, 0)
	delorean:render()

	-- OBSTACLES
	love.graphics.setColor(1, 0.25, 0.25, 1)
	for key, obstacle in ipairs(obstacles) do
		love.graphics.circle('fill', obstacle.x, obstacle.y, obstacle.r)
	end
	love.graphics.setColor(1, 1, 1, 1)

	-- SPEEDOMETER
	love.graphics.setFont(normalFont)
	love.graphics.printf(math.floor(gameSpeed) .. ' MPH', 0, 10, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('hold right to accelerate - spacebar to fly', 0, 45, VIRTUAL_WIDTH, 'center')
end
