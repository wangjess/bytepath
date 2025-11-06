local Circle = {}
Circle.__index = Circle

function Circle:new(x, y, radius)
  local self = {
    x = x,
    y = y,
    radius = radius,
    creation_time = love.timer.getTime()
  }
  setmetatable(self, Circle)

  return self
end

function Circle:update(dt)

end

function Circle:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius, 64)
end

return Circle
