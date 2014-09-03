-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

AI = {}
AI.__index = AI

function AI.create(id, x, screen_width, screen_height)
	local self = setmetatable({}, AI)
	
	self.id = id
	self.screen_width = screen_width
	self.screen_height = screen_height
	self.width = 20
	self.height = 70
	self.x = x
	self.y = (self.screen_height / 2) - (self.height / 2)

	self.speed = 195
	self.color = {255, 255, 255}

	print(string.format("Created AI paddle %d at %d,%d", self.id, self.x, self.y)) --!
	return self
end

function AI:update(dt, ball)
	local dy = self.speed * dt
	if ball.x > (self.screen_width / 2) and ball.dir_x > 0 then
		if (self.y + self.height) / 2 < ((ball.y + ball.height) / 2) - dy then
			self.y = self.y + dy
		elseif (self.y + self.height) / 2 > ((ball.y + ball.height) / 2) + dy then
			self.y = self.y - dy
		end
	else
		if (self.y + self.height) / 2 < (self.screen_height / 2) - dy then
			self.y = self.y + dy
		elseif (self.y + self.height) / 2 > (self.screen_height / 2) + dy then
			self.y = self.y - dy
		end
	end

end

function AI:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
