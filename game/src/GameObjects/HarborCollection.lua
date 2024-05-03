--! file: HarborCollection.lua

-- Pass Object as first argument.
HarborCollection = Object.extend(Object)

local nodeRadiusRatio = 1.2

function HarborCollection.new(self)
    self.harbors = {}
    self.harborCount = 0
end

function HarborCollection.addHarbor(self, x, y, radius)
    print("Adding harbor at: " .. x .. ", " .. y)
    self.harborCount = self.harborCount + 1
    local harborRadius = radius * (self.harborCount * (nodeRadiusRatio - 1) + 1) * 1.2
    local harbor = Harbor(x, y, harborRadius, 2 * (self.harborCount ^ 2))
    table.insert(self.harbors, harbor)
end

function HarborCollection.update(self, dt)
    for i, harbor in pairs(self.harbors) do
        harbor:update(dt)
    end
end

function HarborCollection.draw(self)
    for i, harbor in pairs(self.harbors) do
        harbor:draw()
    end
end

function HarborCollection.getShipCount(self)
    local count = 0
    for i, harbor in pairs(self.harbors) do
        count = count + harbor.shipCount
    end
    return count
end

function HarborCollection.getFirstFreeHarbor(self)
    for i, harbor in pairs(self.harbors) do
        if(harbor.shipCount < harbor.shipCapacity) then
            return harbor
        end
    end
    return nil
end