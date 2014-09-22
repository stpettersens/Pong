-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

Scoreboard = {}
Scoreboard.__index = Scoreboard

function Scoreboard.create(player1, player2, x, y)
	local self = setmetatable({}, Scoreboard)

	self.player1 = player1
	self.player2 = player2

	self.x = x
	self.y = y

	print(string.format("Created scoreboard at %d,%d", self.x, self.y)) --!
	return self
end

function Scoreboard:draw(score1, score2)
	local scores = string.format("%s \t%d - %d \t %s", self.player1, score1, score2, self.player2) 
	love.graphics.print(scores, self.x, self.y)
end
