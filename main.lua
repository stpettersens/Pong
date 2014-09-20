-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

require 'ball'
require 'paddle'
require 'ai'
require 'net-client'
require 'net-paddle'
require 'scoreboard'
require 'announcer'
require 'screentip'

HOST = 1

TITLE = "Pong"
SCREEN_WIDTH = 700
SCREEN_HEIGHT = 500
WINNING_SCORE = 10

PLAYER_1 = "P1"
PLAYER_2 = "P2"

SCORE_PLAYER_1 = 0
SCORE_PLAYER_2 = 0
PLAY_AI = true
GAME_READY = true
GAME_ACTIVE = false
NETWORK_GAME = false
STATE = 'play'

HOSTNAME = "localhost"
PORT = 8989

function love.load()

	love.window.setTitle(TITLE)
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

	ball = Ball.create(SCREEN_WIDTH / 2 , 250, SCREEN_WIDTH, SCREEN_HEIGHT)

	scoreboard = Scoreboard.create(PLAYER_1, PLAYER_2, ((SCREEN_WIDTH / 2) - 50), 25)
	announcer = Announcer.create(((SCREEN_WIDTH / 2) - 45), 130)
	screentip = Screentip.create(((SCREEN_WIDTH / 2) - 30), 200)

	if NETWORK_GAME then
		playHumanNetwork()
	elseif PLAY_AI then 
		playAI()
	else
		playHuman()
	end

	ball:setDirection(1, 1)
end

function playHumanNetwork()
	PLAYER_1 = "p1"
	PLAYER_2 = "P2"

	client = NetClient.create(HOSTNAME, PORT)
	client:selectHost(HOST)

	if HOST == 1 then
		paddle1 = Paddle.create(1, 15, SCREEN_HEIGHT, 'w', 's')
	else 
		paddle2 = Paddle.create(2, (SCREEN_WIDTH - 35), SCREEN_HEIGHT, 'up', 'down')
	end
	netPaddle1 = NetPaddle.create(1, 15, SCREEN_HEIGHT)
	netPaddle2 = NetPaddle.create(2, (SCREEN_WIDTH - 35), SCREEN_HEIGHT)
end

function playAI()
	PLAYER_1 = "P1"
	PLAYER_2 = "COM"
	paddle1 = Paddle.create(1, 15, SCREEN_HEIGHT, 'w', 's')
	ai = AI.create(2, (SCREEN_WIDTH - 35), SCREEN_WIDTH, SCREEN_HEIGHT)
end

function playHuman()
	PLAYER_1 = "P1"
	PLAYER_2 = "P2"
	paddle1 = Paddle.create(1, 15, SCREEN_HEIGHT, 'w', 's')
	paddle2 = Paddle.create(2, (SCREEN_WIDTH - 35), SCREEN_HEIGHT, 'up', 'down')
end

function love.update(dt)
	if STATE ~= 'play' then
		return nil
	end

	if GAME_ACTIVE then

		if NETWORK_GAME then
			if HOST == 1 then
				paddle1:update(dt)
				client:transmitPaddle(paddle1)
				--netPaddle1:setPos(client:receive())
				local y = netPaddle1:getPos()
				netPaddle1:update(dt, y)
			else
				paddle2:update(dt)
				client:transmitPaddle(paddle2)
				--netPaddle2:setPos(client:receive())
				local y = netPaddle2:getPos()
				netPaddle2:update(dt, y)
			end
			--setNetworkScore()
		end

		if PLAY_AI then
			ai:update(dt, ball)
			paddle1:update(dt)
			ball:hitA(paddle1)
			ball:hitB(ai)
			ball:bounce()
			ball:update(dt)	
			
		elseif NETWORK_GAME == false then
			paddle1:update(dt)
			paddle2:update(dt)
			ball:hitA(paddle1)
			ball:hitB(paddle2)
			ball:bounce()
			ball:update(dt)
		end
		
		SCORE_PLAYER_2 = ball:scoreA()
		SCORE_PLAYER_1 = ball:scoreB()
		checkScore()
	end
end

function love.draw()
	if GAME_ACTIVE then

		if NETWORK_GAME then
			if HOST == 1 then
				paddle1:draw()
				netPaddle2:draw()
			else
				paddle2:draw()
				netPaddle1:draw()
				print(netPaddle1:getPos()) --!
			end
		end
		
		if PLAY_AI then
			ai:draw()
			ball:draw()
			paddle1:draw()

		elseif NETWORK_GAME == false then
			paddle1:draw()
			paddle2:draw()
			ball:draw()
		end

		scoreboard:draw(SCORE_PLAYER_1, SCORE_PLAYER_2)

	elseif GAME_ACTIVE == false and GAME_READY == false then
		announceGameOver()
	elseif GAME_ACTIVE == false and GAME_READY == true then
		selectOpponent()
	end
	if STATE == 'pause' then
		screentip:draw("PAUSED", "Press P to resume play")
	end
end


function love.keypressed(key)
	if GAME_READY and key == '1' then
		PLAY_AI = false
		NETWORK_GAME = false
		PLAYER_2 = "P2"
		setupGame()
	elseif GAME_READY and key == '2' then
		PLAY_AI = true
		NETWORK_GAME = false
		PLAYER_2 = "COM"
		setupGame()
	elseif GAME_READY and key == '3' then
		PLAY_AI = false
		NETWORK_GAME = true
		PLAYER_2 = "P2"
		setupGame()
	elseif GAME_ACTIVE and NETWORK_GAME == false and key == 'p' then
		if STATE == 'play' then
			STATE = 'pause'
		else
			STATE = 'play'
		end
	elseif GAME_ACTIVE == false and key == 'n' then
		love.event.quit()
	elseif GAME_ACTIVE == false and key == 'y' then
		selectOpponent()
	end
end

function setNetworkScore()
	if NETWORK_GAME then
		client:transmitScore(string.format("%d,%d", SCORE_PLAYER_1, SCORE_PLAYER_2))
		local scores = client:receive()
		local score1, score2 = scores:match("([^,]+),([^,]+)")
		SCORE_PLAYER_1, SCORE_PLAYER_2 = tonumber(score1), tonumber(score2)
	end
end

function checkScore()
	if SCORE_PLAYER_1 == WINNING_SCORE or SCORE_PLAYER_2 == WINNING_SCORE then
		GAME_ACTIVE = false
		GAME_READY = false
	end
end

function announceGameOver()
	local player = 0
	local score1 = 0
	local score2 = 0
	if SCORE_PLAYER_1 > SCORE_PLAYER_2 then
		player = 1
		score1 = SCORE_PLAYER_1
		score2 = SCORE_PLAYER_2
	elseif SCORE_PLAYER_2 > SCORE_PLAYER_1 then
		player = 2
		score1 = SCORE_PLAYER_2
		score2 = SCORE_PLAYER_1
	end
	announcer:draw(player, score1, score2)
	screentip:draw("Play again?", "(Y) Yes\t\t\t(N) No")
end

function selectOpponent()
	GAME_READY = true
	screentip:draw("Select opponent", "(1) Local Human\t(2) Computer\t(3) Network Human")
end

function setupGame()
	GAME_READY = false
	GAME_ACTIVE = true
	STATE = 'play'
	SCORE_PLAYER_1 = 0
	SCORE_PLAYER_2 = 0
	love.load()
end
