local Circle = {}
Circle.__index = Circle

function Circle:new(x, y, radius)
	local self = setmetatable({}, Circle)
	self.x = x 
	self.y = y 
	self.radius = radius 
  self.creation_time = love.timer.getTime()
	return self
end

function Circle:update(dt)

end

function Circle:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius, 64)
end

return Circle
