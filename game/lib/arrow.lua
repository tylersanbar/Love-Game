function love.graphics.arrow(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle))
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
end

function love.graphics.arrow2(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle))
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
	local a = math.atan2(y2 - y1, x2 - x1)
	love.graphics.line(x1, y1, x1 + arrlen * math.cos(a + angle), y1 + arrlen * math.sin(a + angle))
	love.graphics.line(x1, y1, x1 + arrlen * math.cos(a - angle), y1 + arrlen * math.sin(a - angle))
end

function love.graphics.arrow3(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.polygon('fill', x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle), x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
end

function love.graphics.arrow4(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.polygon('fill', x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle), x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
	local a = math.atan2(y2 - y1, x2 - x1)
	love.graphics.polygon('fill', x1, y1, x1 + arrlen * math.cos(a + angle), y1 + arrlen * math.sin(a + angle), x1 + arrlen * math.cos(a - angle), y1 + arrlen * math.sin(a - angle))
end