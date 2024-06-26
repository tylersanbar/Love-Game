--! file: Ship.lua

-- Pass Object as first argument.
Ship = Object.extend(Object)
CURRENT_SHIP_ID = 0
local shipRadius = 2;

function Ship.new(self, x, y, harbor, team)
    self.id = CURRENT_SHIP_ID
    CURRENT_SHIP_ID = CURRENT_SHIP_ID + 1
    self.body = love.physics.newBody(G.world, x, y, "dynamic")
    self.body:setMass(1)
    self.shape = love.physics.newCircleShape(shipRadius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setRestitution(1)
    self.fixture:setFriction(0)
    self.type = "ship"
    self.team = team
    self.color = COLORS.blue
    self.harbor = harbor
    self.task = 'seekHarbor'
    self.targetX, self.targetY = self:getClosestHarborPoint()
    self.velocity = 100
    self.destroyed = false
end

function Ship.handleCollision(self, other)
    if(other == nil) then
        return
    end
    if(other.type == 'node') then
        self:handleNodeCollision(other)
    elseif(other.type == 'ship') then
        self:handleShipCollision(other)
    end
end

function Ship.handleNodeCollision(self, node)
    if(node.team == self.team) then
        if(self.harbor.collection.node == node) then
            return
        end
        self.removeFromNode(self)
        self.addToNode(self, node)
        return
    end
    self:handleEnemyNodeCollision(node)
end

function Ship.handleEnemyNodeCollision(self, node)
    if(node.shipCount == 0) then
        self.removeFromNode(self)
        node.team = self.team
        self.addToNode(self, node)
        return
    end
    local ship = node.ships[#node.ships]
    ship:destroy()
    self:destroy()
end

function Ship.handleShipCollision(self, ship)
    if(ship.team == self.team) then
        self.moveToAntiPodalPosition(ship)
        return
    end
    self:handleEnemyShipCollision()
end

function Ship.moveToAntiPodalPosition(self)
    local harbor = self.harbor
    local angle = M.angleBetween(self.body:getX(), self.body:getY(), harbor.x, harbor.y)
    self.targetX = harbor.x + math.cos(angle) * harbor.radius
    self.targetY = harbor.y + math.sin(angle) * harbor.radius
    self.task = "teleport"
end

function Ship.moveToRandomPosition(self)
    local harbor = self.harbor
    local angle = math.random(0, math.pi * 2)
    self.targetX = harbor.x + math.cos(angle) * harbor.radius
    self.targetY = harbor.y + math.sin(angle) * harbor.radius
    self.task = "teleport"
end

function Ship.handleEnemyShipCollision(self)
    self:destroy()
end

function Ship.destroy(self)
    self.destroyed = true
end

function Ship.log(self)
    print("x:" ..self.body:getX() .. " Y:" .. self.body:getY())
    print("targetX: " ..self.targetX .. " targetY:" .. self.targetY)
    local vx, vy = self.body:getLinearVelocity()
    print("velocityX: " .. vx .. " velocityY: " .. vy)
end

function Ship.handleRemoval(self)
    self:removeFromNode()
    self.body:destroy()
end

function Ship.removeFromNode(self)
    self.harbor.shipCount = self.harbor.shipCount - 1
    self.harbor.collection.node.shipCount = self.harbor.collection.node.shipCount - 1

    -- Create a new table and add only the ships that should not be removed
    local newShips = {}
    for i, ship in ipairs(self.harbor.collection.node.ships) do
        if ship ~= self then
            table.insert(newShips, ship)
        end
    end

    -- Replace the old ships table with the new one
    self.harbor.collection.node.ships = newShips
end

function Ship.addToNode(self, node)
    local harbor = node.harbors:getFirstFreeHarbor()
    if(harbor == nil) then
        node.harbors:addHarbor(node.body:getX(), node.body:getY(), node.radius, 5)
        harbor = node.harbors:getFirstFreeHarbor()
    end
    self.harbor = harbor
    self.harbor.shipCount = self.harbor.shipCount + 1
    self.harbor.collection.node.shipCount = self.harbor.collection.node.shipCount + 1
    table.insert(node.ships, self)
    self.task = "seekHarbor"
    self:seekHarbor()
end

function Ship.update(self, dt)
    if(G.log) then
        self:log()
    end
    if(self.destroyed) then
        self:handleRemoval()
        return
    end
    if(self.task == nil) then
        return
    elseif(self.task == "seekHarbor") then
        self:seekHarbor(dt)
    elseif(self.task == "orbit") then
        self:orbit(dt)
    elseif(self.task == "seekTarget") then
        self:seekTarget(dt)
    elseif(self.task == "teleport") then
        self:teleport(dt)
    end
end

function Ship.teleport(self, dt)
    self.snapToTarget(self)
    self.task = "seekHarbor"
end

function Ship.setXYVelocity(self, angle)
    return self.body:setLinearVelocity(math.cos(angle) * self.velocity, math.sin(angle) * self.velocity)
end

function Ship.seekHarbor(self, dt)
    self:targetClosestHarbor()
    local distance = M.distance(self.body:getX(), self.body:getY(), self.targetX , self.targetY)
    if(distance < .5) then
        self.snapToTarget(self)
        self.task = "orbit"
        return
    end
    self:seekTarget(dt)
end

function Ship.snapToTarget(self)
    self.body:setLinearVelocity(0, 0)
    self.body:setX(self.targetX)
    self.body:setY(self.targetY)
end

function Ship.orbit(self, dt)
    self:targetClosestHarbor()
    local distanceT = M.distance(self.body:getX(), self.body:getY(), self.targetX , self.targetY)
    if(distanceT > 1) then
        self.task = "seekHarbor"
        return
    end
    local distanceC = M.distance(self.body:getX(), self.body:getY(), self.harbor.x, self.harbor.y)

    local angle = M.getClockwiseTangentAngle(self.body:getX(), self.body:getY(), self.harbor.x, self.harbor.y)
    if(distanceC - self.harbor.radius > .5) then
        angle = angle - .01
    end
    if(distanceC - self.harbor.radius < .5) then
        angle = angle + .01
    end
    self.setXYVelocity(self, angle)
end

function Ship.targetClosestHarbor(self)
    self.targetX, self.targetY = self:getClosestHarborPoint()
end

function Ship.getClosestHarborPoint(self)
    return M.closestPointOnCircle(self.body:getX(), self.body:getY(), self.harbor.x, self.harbor.y, self.harbor.radius)
end

function Ship.seekTarget(self, dt)
    local angle = M.angleBetween(self.body:getX(), self.body:getY(), self.targetX, self.targetY)
    self.setXYVelocity(self, angle)
end

function Ship.draw(self)
    --self:drawTargetLine()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), shipRadius)

end

function Ship.drawTargetLine(self)
    love.graphics.setColor(COLORS.red)
    love.graphics.line(self.body:getX(), self.body:getY(), self.targetX, self.targetY)
end

function Ship.setTarget(self, target)
    self.targetX = target.body:getX()
    self.targetY = target.body:getY()
    self.task = "seekTarget"
end