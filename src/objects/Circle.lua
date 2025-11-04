local Circle = {}
Circle.__index = Circle

function Circle:new(x, y, radius, color)
	local self = setmetatable({}, Circle)
	self.x = x 
	self.y = y 
	self.radius = radius 
	self.color = color 
  self.creation_time = love.timer.getTime()
	return self
end

function Circle:update(dt)

end

function Circle:draw()
end

return Circle
