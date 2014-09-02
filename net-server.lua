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

	-- Initialise paddle position variables.
	self.paddle1_posX, self.paddle1_posY = nil, nil
	self.paddle2_posX, self.paddle2_posX = nil, nil

	-- Initialise ball position variables
	self.ball_posX, self.ball_posY = nil, nil

	print("Created NetServer") -- !

	return self
end

function NetServer:listen()
	local data, msg_or_ip, port_or_nil
	local running = true
	print "Begin server loop..."
	while running do
		data, msg_or_ip, port_or_nil = self.udp:receivefrom()
		if data then
			print(data) -- !
			cmd, param1, param2 = data:match("^(%w*) (%w%d*) (%d*,%d*)")
			if cmd == "POS" then
				print(param2) -- !
				local x, y = param2:match("([^,]+),([^,]+)")
				if param1 == "P1" then
					self.paddle1_posX, self.paddle1_posY = tonumber(x), tonumber(y)
				elseif param1 == "P2" then
					self.paddle2_posX, self.paddle2_posY = tonumber(x), tonumber(y)
				else
					self.ball_posX, self.ball_posY = tonumber(x), tonumber(y)
				end
			elseif cmd == "QUIT" then
				-- do something
			end
			end
			print('X ' .. self.paddle1_posX) -- !
			print('Y ' .. self.paddle1_posY) -- !
		end
	end
end


--[[PORT = 8989

local socket = require 'socket'
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', PORT)

local data, msg_or_ip, port_or_nil
local running = true

print "Beginning server loop..."
while running do
	data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
		print(data)
		cmd, params = data:match("^(%w*) (%w*)")
		if cmd == "POS" then
			udp:sendto(data, msg_or_ip, port_or_nil)
		elseif cmd == "QUIT" then
			running = false
		end
	end
end]]--
