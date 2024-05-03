--! file: Node.lua

-- Pass Object as first argument.
Node = Object.extend(Object)

function Node.new(self, x, y, radius, initialShipCount, team)
    self.team = team
    self.body = love.physics.newBody(G.world, x, y, "static")
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setCategory(team)
    self.radius = radius
    self.harbors = HarborCollection()
    self.harbors:addHarbor(x, y, self.radius)
    self.maxShips = 100
    self.color = G.C.white
    self.ships = {}
    self.shipCount = 0
    for i = 1, initialShipCount, 1 do
        self:spawnShip()
    end
    self.lastSpawnTime = 0.0
    self.spawnSpeed = 1
    self.shouldSpawn = true
    print("Node created at: " .. self.body:getX() .. ", " .. self.body:getY())
    print("Node has " .. self.shipCount .. " ships")
end

function Node.draw(self)
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius)
    self:drawCount()
    if(self.arrow ~= nil) then
        self.arrow.draw(self.arrow)
    end
    self:drawShips()
end

function Node.drawShips(self)
    for i, ship in pairs(self.ships) do
        ship:draw()
    end
end

function Node.drawCount(self)
    love.graphics.setColor(G.C.black)
    local text = tostring(self.shipCount)
    local font = love.graphics.getFont()
    local text_w = font:getWidth(text)
    local text_h = font:getHeight()
    love.graphics.printf(self.shipCount, self.body:getX() - text_w/2, self.body:getY() - text_h/2, text_w, "center")
end

function Node.update(self, dt)
    if(self.arrow ~= nil) then
        self.arrow.update(self.arrow, love.mouse.getX(), love.mouse.getY())
    end
    self.harbors:update(dt)
    self:updateShips(dt)
    self:checkForSpawnShips()
end

function Node.updateShips(self, dt)
    for i, ship in pairs(self.ships) do
        ship:update(dt)
    end
end

function Node.updateHarbors(self, dt)
    self.harbors:update(dt)
end

function Node.checkForSpawnShips(self)
    if(G.time - self.lastSpawnTime > self.spawnSpeed) then
        if(self.shouldSpawn and self.shipCount < self.maxShips) then
            self:spawnShip()
            self.lastSpawnTime = G.time
        end
    end
end

function Node.spawnShip(self)
    local harbor = self.harbors:getFirstFreeHarbor()
    if(harbor == nil) then
        self.harbors:addHarbor(self.body:getX(), self.body:getY(), self.radius, 5)
        harbor = self.harbors:getFirstFreeHarbor()
    end
    local ship = Ship(self.body:getX(), self.body:getY(), harbor, self.team)
    self.ships[self.shipCount] = ship
    harbor.shipCount = harbor.shipCount + 1
    self.shipCount = self.shipCount + 1
end

function Node.isWithin(self, x, y)
    local distance = M.distance(self.body:getX(), self.body:getY(), x, y)
    return distance < self.radius
end

function Node.spawnArrow(self, x, y)
    print("Arrow spawned at: " .. x .. ", " .. y)
    self.arrow = Arrow(x, y, self)
end

function Node.handleMousePressed(self)
    if(self:isWithin(love.mouse.getX(), love.mouse.getY())) then
        self.color = G.C.blue
        if(self.arrow == nil) then
            self:spawnArrow(love.mouse.getX(), love.mouse.getY())
        end
    end
end

function Node.handleMouseReleased(self)
    local x, y = love.mouse.getPosition()
    print("Mouse released at: " .. x .. ", " .. y)
    if(self.arrow ~= nil) then
        local target = G:findNode(x, y)
        if(target ~= nil and target ~= self) then
            self.moveShips(self, target)
        end
        self.arrow = nil
        self.color = G.C.white
    else
        if(self:isWithin(x, y)) then
            self.color = G.C.red
        end
    end
end

function Node.moveShips(self, target)
    for i, ship in pairs(self.ships) do
        ship:setTarget(target)
    end
end

