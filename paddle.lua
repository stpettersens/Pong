-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

Paddle = {}
Paddle.__index = Paddle

function Paddle.create(id, x, screen_height, up, down)
	local self = setmetatable({}, Paddle)
	
	self.id = id
	self.screen_height = screen_height
	self.up = up
	self.down = down
	self.width = 20
	self.height = 70
	self.x = x
	self.y = (self.screen_height / 2) - (self.height / 2)
	
	self.speed = 400
	self.color = {255, 255, 255}
	print("Created paddle " .. self.id .. " at " .. self.x .. ", " .. self.y) --!
	return self
end

function Paddle:update(dt)
	if love.keyboard.isDown(self.up) then
		self.y = self.y - (self.speed * dt)
	end
	if love.keyboard.isDown(self.down) then
		self.y = self.y + (self.speed * dt)
	end

	if self.y < 0 then
		self.y = 0
	elseif (self.y + self.height) > self.screen_height then
		self.y = self.screen_height - self.height
	end
end

function Paddle:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
