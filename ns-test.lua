-- NetSocket test!

require 'net-client'
require 'paddle'
require 'ball'

client = NetClient.create("localhost", 8989)
paddle = Paddle.create(1, 250, 250, 'w', 's')
ball = Ball.create(200, 250, 500, 600)


client:transmitPaddle(paddle)
print(client:receivePos())
