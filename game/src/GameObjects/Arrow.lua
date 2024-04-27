--! file: Arrow.lua

-- Pass Object as first argument.
Arrow = Object.extend(Object)

local white = {1, 1, 1, 1}

function Arrow.new(self, x, y, parent)
	self.parent = parent
	self.startX = x
	self.startY = y
	self.endX = x
	self.endY = y
	self.length = 10
	self.angle = math.pi/6
	print("Arrow created at: " .. self.startX .. ", " .. self.startY)
end

function Arrow.update(self, x, y)
	--print("Arrow updated to: " .. x .. ", " .. y)
	self.endX = x
	self.endY = y
end

function Arrow.draw(self)
	--print("Arrow drawn from: " .. self.startX .. ", " .. self.startY .. " to: " .. self.endX .. ", " .. self.endY)
	love.graphics.setColor(white)
	love.graphics.arrow(self.startX, self.startY, self.endX, self.endY, self.length, self.angle)
	love.graphics.print("X: " .. self.endX .. " Y: " .. self.endY, self.endX, self.endY)
end

