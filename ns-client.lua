-- Net Client test!

require 'net-client'
require 'paddle'
require 'ball'

client = NetClient.create("localhost", 8989)
paddle1 = Paddle.create(1, 250, 250, 'w', 's')
paddle2 = Paddle.create(2, 500, 500, 'up', 'down')
ball = Ball.create(200, 250, 500, 600)

client:transmitPaddle(paddle1)
paddle1:setPos(client:receive())

client:transmitPaddle(paddle2)
paddle2:setPos(client:receive())
