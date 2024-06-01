-- Base GameObject class
GameObject = Object.extend(Object)

function GameObject.new(self, id, x, y, shapeData, team, color)
    self.id = id
    self.team = team
    self.color = color or COLORS.white
    self.type = 'generic'

    -- Delegate shape creation to a ShapeFactory
    local shapeHandler = ShapeFactory.create(shapeData)
    self.body, self.fixture = shapeHandler:createBodyAndFixture(x, y)
    self.fixture:setUserData(self)
end

function GameObject.draw(self)
    love.graphics.setColor(self.color)
    -- Delegate drawing to the shape handler
    self.shapeHandler:draw(self.body)
end

-- ShapeFactory with simple conditional logic
ShapeFactory = {}
function ShapeFactory.create(shapeData)
    if shapeData.type == 'circle' then
        return CircleShape(shapeData.radius)
    elseif shapeData.type == 'rectangle' then
        return RectangleShape(shapeData.width, shapeData.height)
    end
end

-- Specific shape handler for circles
CircleShape = Object.extend(Object)
function CircleShape.new(self, radius)
    self.radius = radius
end

function CircleShape:createBodyAndFixture(x, y)
    local body = love.physics.newBody(G.world, x, y, "static")
    local shape = love.physics.newCircleShape(self.radius)
    local fixture = love.physics.newFixture(body, shape)
    return body, fixture
end

function CircleShape:draw(body)
    love.graphics.circle("fill", body:getX(), body:getY(), self.radius)
end

-- You would define RectangleShape in a similar way
