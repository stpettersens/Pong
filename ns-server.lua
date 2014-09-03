-- Net Server test!

require 'net-server'
require 'paddle'
require 'ball'

server = NetServer.create("localhost", 8989)
server:listen()
