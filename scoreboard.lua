-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

Scoreboard = {}
Scoreboard.__index = Scoreboard

function Scoreboard.create(x, y)
	local self = setmetatable({}, Scoreboard)

	self.x = x
	self.y = y

	print("Created scoreboard at " .. self.x .. ", " .. self.y) --!
	return self
end

function Scoreboard:draw(score1, score2)
	local scores = score1 .. " - " .. score2
	love.graphics.print(scores, self.x, self.y)
end
