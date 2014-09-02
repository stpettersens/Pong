-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

SCORE_PLAYER_1 = 0
SCORE_PLAYER_2 = 0
Ball = {}
Ball.__index = Ball

function Ball.create(x, y, screen_width, screen_height)
	local self = setmetatable({}, Ball)
	
	self.width = 20
	self.height = 20
	self.x = x
	self.y = y
	self.screen_width = screen_width
	self.screen_height = screen_height

	self.speed_x = -200
	self.speed_y = 200
	self.speed = 200
	self.color = {255, 255, 255}
	self.dir_x = 0
	self.dir_y = 0

	print("Created ball at " .. self.x .. ", " .. self.y) --!
	return self
end

function Ball:setDirection(x, y)
	local len = math.sqrt((x * x) + (y * y))
	self.dir_x = 200 * (x / len)
	self.dir_y = 200 * (y / len)
end

function Ball:scoreA()
	if self.x + self.width < 0 then
		self.x = self.screen_width / 2
		self.y = 250
		SCORE_PLAYER_2 = SCORE_PLAYER_2 + 1
	end
	return SCORE_PLAYER_2
end
	
function Ball:scoreB()
	if self.x > (self.screen_width - 5) then
		self.x = self.screen_width / 2
		self.y = 250
		SCORE_PLAYER_1 = SCORE_PLAYER_1 + 1 
	end
	return SCORE_PLAYER_1
end

function Ball:bounce()
	if self.y < 0 then
		self.speed_y = math.abs(self.speed_y)
	elseif (self.y + self.height) >= self.screen_height then
		self.speed_y = -math.abs(self.speed_y)
	end
end

function Ball:playHit()
	local sfx = love.audio.newSource("sfx/ball-hit.ogg", "static")
	love.audio.play(sfx)
end

function Ball:hitA(paddle)
	if self.x <= paddle.width and (self.y + self.height) >= paddle.y
	and self.y < (paddle.y + paddle.height) then
		self.speed_x = math.abs(self.speed_x)
		Ball:setDirection(-1, -1)
		Ball:playHit()
	end
end

function Ball:hitB(paddle)
	if(self.x + self.width) >= (self.screen_width - paddle.width) and
	(self.y + self.height) >= paddle.y 
	and self.y < (paddle.y + paddle.height) then
		self.speed_x = -math.abs(self.speed_x)
		Ball:setDirection(1, -1)
		Ball:playHit()
	end
end

function Ball:update(dt)
	self.x = self.x + (self.speed_x * dt)
	self.y = self.y + (self.speed_y * dt)
end

function Ball:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:getPosStr()
	return tostring('B ' .. self.x .. ',' .. self.y .. ':')
end

function Ball:setPos(position)
	self.x, self.y = position
end
