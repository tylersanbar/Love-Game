--! file: Harbor.lua

-- Pass Object as first argument.
Harbor = Object.extend(Object)

require "src/GameObjects/Ship"
local nodeHarborRatio = 1.5
function Harbor.new(self, x, y, radius, shipCount)
    self.x = x
    self.y = y
    self.radius = radius * nodeHarborRatio
    self.ships = {}
    self.shipCount = 0
    for i = 1, shipCount, 1 do
        self:spawnShip()
    end
    self.lastSpawnTime = 0.0
    self.spawnSpeed = 1.0
end

function Harbor.update(self, dt)
    if(G.time - self.lastSpawnTime > self.spawnSpeed) then
        --self:spawnShip()
        self.lastSpawnTime = G.time
    end
    for i, ship in pairs(self.ships) do
        ship:update(dt)
    end
end

function Harbor.spawnShip(self)
    local ship = Ship(self.x, self.y, 0, self)
    self.ships[self.shipCount] = ship
    self.shipCount = self.shipCount + 1
    --self:redistributeShipPlacement()
end

-- function Harbor.shiftShips(self, shift)
--     self.shipShift = self.shipShift + shift
--     self:redistributeShipPlacement()
-- end

-- function Harbor.redistributeShipPlacement(self)
--     local currentAngle = 0
--     local angleDiff = 2 * math.pi / self.shipCount
--     for i, ship in pairs(self.ships) do
--         self:moveShipToAngle(ship, currentAngle + self.shipShift)
--         currentAngle = currentAngle + angleDiff
--     end
-- end

-- function Harbor.moveShipToAngle(self, ship, angle)
--     ship.angle = angle
--     ship.x = self.x + (self.radius) * math.cos(angle)
--     ship.y = self.y + (self.radius) * math.sin(angle)
-- end

function Harbor.draw(self)
    for i, ship in pairs(self.ships) do
        ship:draw()
    end
    love.graphics.setColor(G.C.purple)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", self.x, self.y, self.radius)
end