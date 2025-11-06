local HyperCircle = {}
HyperCircle.__index = HyperCircle
setmetatable(HyperCircle, {__index = Circle}) -- this is different!

function HyperCircle:new(x, y, radius, line_width, outer_radius)
  -- Start with a regular circle
  local obj = Circle:new(x, y, radius)         -- this is different!

  -- Switch metatable to HyperCircle (so HyperCircle methods take precedence)
  setmetatable(obj, HyperCircle)               

  -- Add extra properties
  obj.line_width = line_width
  obj.outer_radius = outer_radius

  return obj
end

function HyperCircle:update(dt)

end

function HyperCircle:draw()
--  love.graphics.circle("fill", obj.x, obj.y, obj.radius, 64)
--  love.graphics.circle("line", obj.line_width, obj.outer_radius)
end
