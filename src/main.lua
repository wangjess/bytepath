Input = require('libraries/Input')
Timer = require('libraries/hump/timer')

-- Stores the class objects
classes = {}

function love.load()
  local object_files = {}
  local library_files = {}

  -- Get all library files
  recursiveEnumerate('libraries', library_files)
  requireFiles(library_files)
  
  -- Get all object files
  recursiveEnumerate('objects', object_files)
  requireFiles(object_files)

  -- Global timer object
  timer = Timer()
  input = Input()

  -- Testing timer functions:
--  timer:after(2, function() print(love.math.random()) end)
--  timer:every(1, function() print("yo") end, 5) -- stops after 5 occurrences
--  timer:after(1, function(f)
--        print(love.math.random())
--        timer:after(1, f)
--  end)
    
  -- Tween
  circle = {radius = 24}
  timer:tween(6, circle, {radius = 96}, 'in-out-cubic')

--  input:bind('mouse1', 'test')
--  input:bind('mouse1', function() print(love.math.random()) end)
end

-- Imports the files
function requireFiles(files)
  for _, file in ipairs(files) do
    local file = file:sub(1, -5)
    local name = file:match("([^/]+)$")
    
    -- Add the class to our dictionary
    local class = require(file)
    
    -- Error checking for failures, quit if error occurs
    local ok, mod = pcall(require, file)
    if not ok then
      os.exit(1)
    end

    classes[name] = class
  end
end

-- Recursively iterates through directories
function recursiveEnumerate(folder, file_list) 
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
    local file = folder .. '/' .. item
    if love.filesystem.getInfo(file).type == "file" then
      table.insert(file_list, file)
    elseif love.filesystem.getInfo(file).type == "directory" then
      recursiveEnumerate(file, file_list)
    end
  end
end

function love.update(dt)
  timer:update(dt)
end

function love.draw()
  --  Circle
--  local circ = classes.Circle:new(400, 300, 50)
--  circ:draw()

  -- HyperCircle
--  local hyper = classes.HyperCircle:new(400, 300, 50, 10, 120)
--  hyper:draw()

  -- Tween visual testing
  love.graphics.circle('fill', 400, 300, circle.radius)
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

