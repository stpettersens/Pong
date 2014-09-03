-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

NetClient = {}
NetClient.__index = NetClient

function NetClient.create(host, port)
	local self = setmetatable({}, NetClient)

	self.host = host -- Set hostname.
	self.port = port -- Set port.

	-- Load socket namespace.
	self.socket = require "socket"
	-- Convert host name to IP address.
	self.ip = assert(socket.dns.toip(self.host)) 
	-- Create a new UDP object.
	self.udp = assert(socket.udp())

	print("Created NetClient") -- !
	return self
end

function NetClient:selectHost(id)
	assert(self.udp:sendto(string.format("HOST %s 0,0", id), self.ip, self.port))
end

function NetClient:transmitPaddle(paddle)
	assert(self.udp:sendto(string.format("POS %s", paddle:getPosStr()), self.ip, self.port))
end

function NetClient:transmitScore(score1, score2)
	assert(self.udp:sendto(string.format("SCORE P1 %s,%s", score1, score2), self.ip, self.port))
end

function NetClient:receive()
	return self.udp:receive()
end

function NetClient:quit()
	assert(self.udp:sendto("QUIT", self.ip, self.port))
end
