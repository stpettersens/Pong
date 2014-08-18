-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

Announcer = {}
Announcer.__index = Announcer

function Announcer.create(x, y)
	local self = setmetatable({}, Announcer)

	self.x = x
	self.y = y

	print("Created announcer at " .. self.x .. ", " .. self.y) --!
	return self
end

function Announcer:draw(player, score)
	local announcement = "blah"
	if player == 1 then
		announcement = "Player 1 wins with " .. score .. " points!"
	elseif player == 2 then
		announcement = "Player 2 wins with " .. score .. " points!"
	end
	love.graphics.print(announcement, self.x, self.y)
end
