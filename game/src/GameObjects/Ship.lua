--! file: Ship.lua

-- Pass Object as first argument.
Ship = Object.extend(Object)

local shipRadius = 2;

function Ship.new(self, x, y, harbor, team)
    self.body = love.physics.newBody(G.world, x, y, "dynamic")
    self.body:setMass(1)
    self.shape = love.physics.newCircleShape(shipRadius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(1)
    self.fixture:setFriction(0)
    self.fixture:setCategory(G.CATEGORIES.ship, team)
    self.fixture:setMask(G.CATEGORIES.node, team)
    self.color = G.C.blue
    self.harbor = harbor
    self.task = 'seekHarbor'
    self.targetX, self.targetY = self:getClosestHarborPoint()
    self.velocity = 100
end

function Ship.log(self)
    print("x:" ..self.body:getX() .. " Y:" .. self.body:getY())
    print("targetX: " ..self.targetX .. " targetY:" .. self.targetY)
    local vx, vy = self.body:getLinearVelocity()
    print("velocityX: " .. vx .. " velocityY: " .. vy)
end

function Ship.update(self, dt)
    if(G.log) then
        self:log()
    end
    if(self.task == nil) then
        return
    elseif(self.task == "seekHarbor") then
        self:seekHarbor(dt)
    elseif(self.task == "orbit") then
        self:orbit(dt)
    elseif(self.task == "seekTarget") then
        self:seekTarget(dt)
    end
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
    love.graphics.setColor(G.C.red)
    love.graphics.line(self.body:getX(), self.body:getY(), self.targetX, self.targetY)
end

function Ship.setTarget(self, target)
    self.targetX = target.body:getX()
    self.targetY = target.body:getY()
    self.task = "seekTarget"
end