-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

NetServer = {}
NetServer.__index = NetServer

function NetServer.create(host, port)
	local self = setmetatable({}, NetServer)

	self.host = host -- Set hostname.
	self.port = port -- Set port.

	-- Load socket namespace.
	self.socket = require "socket"
	-- Set up UDP socket.
	self.udp = socket.udp()
	self.udp:setsockname("*", port)

	-- Convert host name to IP address.
	self.ip = assert(socket.dns.toip(self.host)) 

	self.udp:settimeout(0)

	-- Intialize who is the host (i.e. the transmitter of co-ordinates for paddles and ball)
	self.host = nil

	-- Initialise paddle position variables.
	self.paddle1_posX, self.paddle1_posY = nil, nil
	self.paddle2_posX, self.paddle2_posX = nil, nil

	-- Initialise ball position variables
	self.ball_posX, self.ball_posY = nil, nil

	-- Initialise score variables
	self.score1, self.score2 = nil, nil

	--print("Created NetServer") -- !

	return self
end

function NetServer:listen()
	local data, msg_or_ip, port_or_nil
	local running = true
	print "Ready..."
	while running do
		data, msg_or_ip, port_or_nil = self.udp:receivefrom()
		if data then
			cmd, param1, param2 = data:match("^(%w*) (%w%d*) (%d*,%d*)")
			if cmd == "HOST" then
				print(string.format("Selected %s as host...", param1))
				self.host = param1
				self.udp:sendto(string.format("%s", self.host), msg_or_ip, port_or_nil)
			elseif cmd == "POS" then
				local x, y = param2:match("([^,]+),([^,]+)")
				if param1 == "P1" then
					self.paddle1_posX, self.paddle1_posY = tonumber(x), tonumber(y)
					print(string.format("POS P1 %d,%d", self.paddle1_posX, self.paddle1_posY))
					self.udp:sendto(string.format("%d,%d", self.paddle1_posX, self.paddle1_posY), msg_or_ip, port_or_nil)
				elseif param1 == "P2" then
					self.paddle2_posX, self.paddle2_posY = tonumber(x), tonumber(y)
					print(string.format("POS P2 %d,%d", self.paddle2_posX, self.paddle2_posY))
					self.udp:sendto(string.format("%d,%d", self.paddle2_posX, self.paddle2_posY), msg_or_ip, port_or_nil)
				else
					self.ball_posX, self.ball_posY = tonumber(x), tonumber(y)
					self.udp:sendto(string.format("%d,%d", self.ball_posX, self.ball_posY), msg_or_ip, port_or_nil)
				end
			elseif cmd == "SCORE" then
				local score1, score2 = param2:match("([^,]+),([^,]+)")
				if param1 == "P1" then
					self.score1, self.score2 = tonumber(score1), tonumber(score2)
					self.udp:sendto(string.format("%d,%d", self.score1, self.score2), msg_or_ip, port_or_nil)
				end
			elseif cmd == "QUIT" then
				print "Terminated..."
				running = false
			end
		end
	end
end
