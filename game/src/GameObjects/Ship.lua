--! file: Ship.lua

-- Pass Object as first argument.
Ship = Object.extend(Object)

local shipRadius = 3;

function Ship.new(self, x, y, angle, parent)
    self.body = love.physics.newBody(G.world, x, y, "dynamic")
    self.body:setMass(1)
    self.shape = love.physics.newCircleShape(shipRadius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setAngle(angle)
    --self.body:setLinearVelocity(math.random(-1, 1), math.random(-1, 1))
    self.color = G.C.blue
    self.parent = parent
    self.targetX = x
    self.targetY = y
    self.maxAcceleration = 100
end

function Ship.update(self, dt)
    self:triggerMove(dt)
end

function Ship.triggerMove(self, dt)
    local tx, ty = self:getClosestHarborPoint()
    self.targetX = tx
    self.targetY = ty
    local distanceX = math.abs(self.targetX - self.body:getX())
    local distanceY = math.abs(self.targetY - self.body:getY())
    print("DistanceX: " .. distanceX)
    print("DistanceY: " .. distanceY)
    if(distanceX < .5 and distanceY < .5) then
        self:snapToTarget()
        self:applyClockwiseTangentForce(dt)
    else
        self:seekTarget(dt)
    end
end

function Ship.snapToTarget(self)
    self.body:setX(self.targetX)
    self.body:setY(self.targetY)
end

function Ship.applyClockwiseTangentForce(self, dt)
    local angle = math.atan2(self.body:getY() - self.parent.y, self.body:getX() - self.parent.x)
    local forceX = math.cos(angle + math.pi/2) * 50
    local forceY = math.sin(angle + math.pi/2) * 50
    self.body:applyForce(forceX, forceY)
end

function Ship.getClosestHarborPoint(self)
    local parentX = self.parent.x
    local parentY = self.parent.y
    local dx = self.body:getX() - parentX
    local dy = self.body:getY() - parentY
    if(dx == 0 and dy == 0) then
        local x = parentX + self.parent.radius * math.cos(math.random(0, 2 * math.pi))
        local y = parentY + self.parent.radius * math.sin(math.random(0, 2 * math.pi))
        return x, y
    end
    local distance = math.sqrt(dx * dx + dy * dy)
    local x = parentX + self.parent.radius * dx / distance
    local y = parentY + self.parent.radius * dy / distance
    return x, y
end

function Ship.seekTarget(self, dt, targetX, targetY)
    -- Get the current velocity
    local velocityX, velocityY = self.body:getLinearVelocity()
    -- Calculate the desired velocity
    local dx = self.targetX - self.body:getX()
    local dy = self.targetY - self.body:getY()
    local distance = math.sqrt(dx * dx + dy * dy)
    local desired_velocity_x = dx / distance * self.maxAcceleration
    local desired_velocity_y = dy / distance * self.maxAcceleration
    -- Apply force based on the difference between the desired velocity and the current velocity
    local forceX = (desired_velocity_x - velocityX) * self.body:getMass() / dt
    local forceY = (desired_velocity_y - velocityY) * self.body:getMass() / dt
    self.body:applyForce(forceX, forceY)
end

function Ship.findClosestShip(self)
    local closestShip = nil
    local closestDistance = 1000000
    for i, node in pairs(G.nodes) do
        for j, ship in pairs(node.harbor.ships) do
            local distance = math.sqrt((self.x - ship.x)^2 + (self.y - ship.y)^2)
            if distance < closestDistance then
                closestDistance = distance
                closestShip = ship
            end
        end
    end
    return closestShip
end

function Ship.draw(self)
    self:drawTargetLine()

    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), shipRadius)

end

function Ship.drawTargetLine(self)
    love.graphics.setColor(G.C.red)
    love.graphics.line(self.body:getX(), self.body:getY(), self.targetX, self.targetY)
end