-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

Screentip = {}
Screentip.__index = Screentip

function Screentip.create(x, y)
	local self = setmetatable({}, Screentip)

	self.x = x
	self.y = y

	print(string.format("Created screentip at %d,%d", self.x, self.y)) --!
	return self
end

function Screentip:draw(title, message)
	love.graphics.print(title, self.x, self.y)
	love.graphics.print(message, (self.x - 40), (self.y + 20))
end
