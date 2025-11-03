local Circle = {}
Circle.__index = Circle

function Circle:new(x, y, radius, color)
	local self = setmetatable({}, Circle)
	self.x = x or 0
	self.y = y or 0
	self.radius = radius or 10
	self.color = color or {1, 0, 0} -- Default: red
	return self
end

function Circle:update(dt)

end

function Circle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Circle
