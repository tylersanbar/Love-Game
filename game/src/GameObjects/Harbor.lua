--! file: Harbor.lua

-- Pass Object as first argument.
Harbor = Object.extend(Object)

require "src/GameObjects/Ship"

function Harbor.new(self, x, y, radius, capacity, collection)
    self.x = x
    self.y = y
    self.radius = radius
    self.shipCount = 0
    self.shipCapacity = capacity
    self.collection = collection
    print("Harbor created with capacity: " .. self.shipCapacity)
end

function Harbor.update(self, dt)
end

function Harbor.draw(self)
    love.graphics.setColor(G.C.purple)
    love.graphics.setLineWidth(1)
    --love.graphics.circle("line", self.x, self.y, self.radius)
end