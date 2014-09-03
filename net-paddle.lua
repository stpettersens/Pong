-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

NetPaddle = {}
NetPaddle.__index = NetPaddle

function NetPaddle.create(id, x, screen_height)
	local self = setmetatable({}, NetPaddle)
	
	self.id = id
	self.screen_height = screen_height
	self.width = 20
	self.height = 70
	self.x = x
	self.y = (self.screen_height / 2) - (self.height / 2)
	
	self.speed = 400
	self.color = {255, 255, 255}
	print(string.format("Created net paddle %d at %d,%d", self.id, self.x, self.y)) --!
	return self
end

function NetPaddle:update(dt, x, y)
	self.x, self.y = x, y
end

function NetPaddle:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function NetPaddle:getPosStr()
	return string.format("P%d %d,%d", self.id, self.x, self.y)
end

function NetPaddle:getPos()
	return self.x, self.y
end

function NetPaddle:setPos(position)
	local x, y = position:match("([^,]+),([^,]+)")
	self.x, self.y = tonumber(x), tonumber(y)
	--print(string.format("Set net paddle %s position at %d,%d", self.id, self.x, self.y)) -- !
end
