local mahth = {}

function mahth.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function mahth.closestPointOnCircle(x, y, cx, cy, r)
    local dx = x - cx
    local dy = y - cy
    local distance = mahth.distance(x, y, cx, cy)
    if(distance == 0) then
        return cx + r * math.cos(math.random(0, 2 * math.pi)), cy + r * math.sin(math.random(0, 2 * math.pi))
    end
    return cx + dx / distance * r, cy + dy / distance * r
end

function mahth.angleBetween(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function mahth.getClockwiseTangentAngle(x, y, c1, c2)
    --Get the angle between the ship and the center of the circle
    return math.pi / 2 + mahth.angleBetween(x, y, c1, c2)
end

function mahth.getClockwiseTangentComponents(x, y, c1, c2)
    --Get the angle between the ship and the center of the circle
    local angle = mahth.angleBetween(x, y, c1, c2)
    --pi/2 is added to the angle to get the tangent angle
    return math.cos(angle + math.pi/2), math.sin(angle + math.pi/2)
end

function mahth.getClockwiseTangentForce(x, y, c1, c2, force)
    --Get the angle between the ship and the center of the circle
    local angle = mahth.angleBetween(x, y, c1, c2)
    --pi/2 is added to the angle to get the tangent angle
    local forceX = math.cos(angle + math.pi/2) * force
    local forceY = math.sin(angle + math.pi/2) * force
    return forceX, forceY
end

function mahth.getFinalVelocity(v0x, v0y, acceleration, dx, dy)
    local vfx = v0x * v0x + 2 * acceleration * dx
    local vfy = v0y * v0y + 2 * acceleration * dy
    return vfx, vfy
end

function mahth.distanceToStop(v, a)
    return v^2 / (2 * a)
end

return mahth