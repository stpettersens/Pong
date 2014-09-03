-- Pong Game Server

require 'net-server'

print "==================================="
print "       PONG GAME SERVER            "
print "==================================="
server = NetServer.create("localhost", 8989)
server:listen()
