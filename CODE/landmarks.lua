-- Use Shift + Click to select a robot
-- When a robot is selected, its variables appear in this editor

-- Use Ctrl + Click (Cmd + Click on Mac) to move a selected robot to a different location



-- Put your global variables here
-- States
AVOID		= "AVOID"
SEARCH	= "SEARCH"
EXPLORE	= "EXPLORE"
CHAIN		= "CHAIN"
SWITCH	= "SWITCH"
FINISHED	= "FINISHED"

-- Collision detection and avoidance parameters
is_obstacle_sensed = false	-- if obstacle found set it to true
collision_index = nil		-- index of the proximity sensor that found the collision

-- Target found flag
is_on_target = false

-- Base Speed
BASE_SPEED		= 10
current_state	= SEARCH

--[[ This function is executed every time you press the 'execute' button ]]
function init()
   -- put your code here
	current_state = SEARCH
	resume_state = SEARCH
end



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
   -- put your code here
	detectCollision()

	if is_on_target then
		robot.wheels.set_velocity(0, 0)
	elseif is_obstacle_sensed then
		avoidCollision()
	else
		robot.wheels.set_velocity(BASE_SPEED, BASE_SPEED)
	end
end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
   -- put your code here
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end



--[[***function avoidCollision()***
Avoid collisions upon detection.
]]
function avoidCollision()
	if collision_index ~= nil then	-- collision found
		if collision_index <= 12 then	-- obstacle on the left side
			robot.wheels.set_velocity(BASE_SPEED, (collision_index - 1) * BASE_SPEED / 11)	-- Steer right by decreasing the right wheel speed
		else -- obstacle on the right side
			robot.wheels.set_velocity((24 - collision_index) * BASE_SPEED / 11, BASE_SPEED) -- Steer left by decreasing the left wheel speed
		end
		is_obstacle_sensed = false
		--current_state = resume_state
	end
end



-- TODO: Detect collision
function detectCollision()
	-- Initialization: index and value for proximity sensors with highest value
	local value = -1	-- highest value found so far
	local index = -1	-- index of the highest value

	-- Update value and index by checking each proximity sensor (1 to 24).
	for i = 1, 24 do	-- By the end of this loop value contains the highest value of sensor and index contains it's index.
		-- Update value and index when ever the previous value is lower than the current proximity sensor value
		if value < robot.proximity[i].value then 
			value = robot.proximity[i].value
			index = i
		end
	end

	-- Update global paramaters for collision avoidance based on the highest proximity sensor value found
	if value == 0  then	-- No obstacle
		is_obstacle_sensed = false
		collision_index = nil
		--current_state = resume_state
	else	-- obstacle found
		is_obstacle_sensed = true
		collision_index = index
	end
end



-- function: is robot found a target
function isOnTarget()
	
end



-- function used to copy two tables
function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end