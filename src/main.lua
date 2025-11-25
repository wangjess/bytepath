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
    
  -- Circle Tween Exercise
  circle = {radius = 24}
  timer:tween(6, circle, {radius = 96}, 'in-out-cubic')

  -- Plus-Sign Tween Exercise
  rect_1 = {x = 400, y = 300, w = 50, h = 200}
  rect_2 = {x = 400, y = 300, w = 200, h = 50}
  
  timer:after(1, function()
    timer:tween(1, rect_1, {w = 0}, 'in-out-cubic', function()
      timer:after(0.3, function()
        timer:tween(1, rect_2, {h = 0}, 'in-out-cubic', function()
         timer:tween(1, rect_1, {w = 50}, 'in-out-cubic')
         timer:tween(1, rect_2, {h = 50}, 'in-out-cubic')
      end)
     end)
    end)
  end)

  -- HP Bar Tweening Exercise
  lag_hp_bar = {x = 300, y = 300, w = 200, h = 50}
  hp_bar = {x = 300, y = 300, w = 200, h = 50}
  input:bind('d', function() timer:tween(1, hp_bar, {w = hp_bar.w - 50}, 'in-out-cubic', function()
    timer:after(0.5, function()
      timer:tween(1, lag_hp_bar, {w = lag_hp_bar.w - 50}, 'in-out-cubic')
    end)
    end) 
  end)

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

  -- Circle Tween 
  -- love.graphics.circle('fill', 400, 300, circle.radius)

  -- Plus-Sign Tween 
--  love.graphics.rectangle('fill', rect_1.x - rect_1.w/2, rect_1.y - rect_1.h/2, rect_1.w, rect_1.h)
--  love.graphics.rectangle('fill', rect_2.x - rect_2.w/2, rect_2.y - rect_2.h/2, rect_2.w, rect_2.h)

  -- HP Bar Tween
  love.graphics.setColor(1, 0.502, 0.502, 1) -- lighter red
  love.graphics.rectangle('fill', lag_hp_bar.x, lag_hp_bar.y, lag_hp_bar.w, lag_hp_bar.h)

  love.graphics.setColor(255, 0, 0) -- bright red
  love.graphics.rectangle('fill', hp_bar.x, hp_bar.y, hp_bar.w, hp_bar.h)

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

