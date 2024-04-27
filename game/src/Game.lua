--! file: Game.lua

-- Pass Object as first argument.
Game = Object.extend(Object)

function Game:new()
    G = self
    self:set_globals()
    self.ships = {}
    self.nodes = {}
    self.time = 0

    love.physics.setMeter(64)
    self.world = love.physics.newWorld(0, 0, true)
end

function Game.update(self, dt)
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

function Game.moveShips(from, to)
    local shipsToMove = from.harbor.shipCount
    for i = 1, shipsToMove, 1 do
        to.harbor:spawnShip(to.harbor)
    end
    from.harbor.shipCount = 0
    from.harbor.ships = {}
end

function Game.startDemo(self)
    self:spawnNode(300, 300, 1)
    return self
end

function Game.spawnNode(self, x, y, shipCount)
    local node = Node(x, y, shipCount)
    table.insert(self.nodes, node)
end

function Game.draw(self)
    for key, node in pairs(self.nodes) do
        node:draw(node)
        node.harbor:draw(node.harbor)
    end
end

function Game.mousepressed(self, x, y, button, istouch, presses)
    for key, node in pairs(self.nodes) do
        node:handleMousePressed(node)
    end
end

function Game.mousereleased(self, x, y, button, istouch, presses)
    for key, node in pairs(self.nodes) do
        node:handleMouseReleased(node)
    end
end