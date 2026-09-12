-- SIMPLE STATE MACHINE: ONLY ONE SCREEN RUNS AT A TIME
-- TITLE, PLAY, AND WIN ARE SWAPPED IN AND OUT HERE
-- ADD A NEW SCREEN LIKE THIS:
-- gStateMachine = StateMachine {
--     ['title'] = function() return TitleScreenState() end,
--     ['play'] = function() return PlayState() end,
-- }
-- gStateMachine:change('play')
StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
