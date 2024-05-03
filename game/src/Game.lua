--! file: Game.lua

-- Pass Object as first argument.
Game = Object.extend(Object)

function Game:new()
    G = self
    self:set_globals()
    self.ships = {}
    self.nodes = {}
    self.time = 0
    self.log = false
    love.physics.setMeter(64)
    self.world = love.physics.newWorld(0, 0, true)
    self.shouldUpdate = true
end

function Game.update(self, dt)
    if(self.shouldUpdate == false) then
        if(not love.keyboard.isDown("k")) then
            return
        end
    end
    self.time = self.time + dt
    for key, node in pairs(self.nodes) do
        node:update(dt)
    end
    self.world:update(dt)
end

function Game.findNode(self, x, y)
    for key, node in pairs(self.nodes) do
        if node:isWithin(x, y) then
            return node
        end
    end
    return nil
end

function Game.startDemo(self)
    self:spawnNode(300, 300, 25, 1, G.CATEGORIES.team1)
    self:spawnNode(400, 300, 25, 1, G.CATEGORIES.team2)
    return self
end

function Game.spawnNode(self, x, y, radius, shipCount, team)
    local node = Node(x, y, radius, shipCount, team)
    table.insert(self.nodes, node)
end

function Game.draw(self)
    for key, node in pairs(self.nodes) do
        node:draw(node)
        node.harbors:draw(node.harbor)
    end
end

function Game.mousepressed(self, x, y, button, istouch, presses)
    for key, node in pairs(self.nodes) do
        node:handleMousePressed(node)
    end
end

function Game.mousereleased(self, x, y, button, istouch, presses)
    for key, node in pairs(self.nodes) do
        node:handleMouseReleased()
    end
end

function Game.keypressed(self, key)
    if key == "space" then
        self.shouldUpdate = not self.shouldUpdate
    elseif key == "l" then
        self.shouldUpdate = true
        self:update(1/60)
        self.shouldUpdate = false
    end
end

function Game.keyreleased(self, key)
end