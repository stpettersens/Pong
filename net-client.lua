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
	self.socket = require("socket") 
	-- Convert host name to IP address.
	self.ip = assert(socket.dns.toip(self.host)) 
	-- Create a new UDP object.
	self.udp = assert(socket.udp())
	print("Created NetClient") -- !
	return self
end

function NetClient:transmitPaddle(paddle)
	assert(self.udp:sendto("POS " .. paddle:getPosStr(), self.ip, self.port))
end

function NetClient:receivePos()
	return self.udp:receive()
end

function NetClient:quit()
	assert(self.udp:sendto("QUIT", self.ip, self.port))
end
