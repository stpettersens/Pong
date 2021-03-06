-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

Announcer = {}
Announcer.__index = Announcer

function Announcer.create(x, y)
	local self = setmetatable({}, Announcer)

	self.x = x
	self.y = y

	print(string.format("Created announcer at %d,%d", self.x, self.y)) --!
	return self
end

function Announcer:draw(player, score1, score2)
	local announcement = string.format("%s wins %d points to %d!", player, score1, score2)
	love.graphics.print("GAME OVER", self.x, self.y)
	love.graphics.print(announcement, (self.x - 30), (self.y + 20))
end
