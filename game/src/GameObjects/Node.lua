--! file: Node.lua

-- Pass Object as first argument.
Node = Object.extend(Object)

function Node.new(self, x, y, shipCount)
    self.x = x
    self.y = y
    self.radius = 100
    self.harbor = Harbor(self.x, self.y, self.radius, shipCount)
    self.color = G.C.white
    print("Node created at: " .. self.x .. ", " .. self.y)
    print("Node has " .. shipCount .. " ships")
end

function Node.draw(self)
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    self:drawCount()
    if(self.arrow ~= nil) then
        self.arrow.draw(self.arrow)
    end
end

function Node.drawCount(self)
    love.graphics.setColor(G.C.black)
    local text = tostring(self.harbor.shipCount)
    local font = love.graphics.getFont()
    local text_w = font:getWidth(text)
    local text_h = font:getHeight()
    love.graphics.printf(self.harbor.shipCount, self.x - text_w/2, self.y - text_h/2, text_w, "center")
end

function Node.update(self, dt)
    if(self.arrow ~= nil) then
        self.arrow.update(self.arrow, love.mouse.getX(), love.mouse.getY())
    end
    self.harbor:update(dt)
end

function Node.isWithin(self, x, y)
    local distance = math.sqrt((self.x - x)^2 + (self.y - y)^2)
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
    if(self.arrow ~= nil) then
        local target = G:findNode(love.mouse.getX(), love.mouse.getY())
        G.moveShips(self, target)
        self.arrow = nil
    else
        if(self:isWithin(love.mouse.getX(), love.mouse.getY())) then
            self.color = G.C.red
        end
    end
end

