-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

require 'ball'
require 'paddle'
require 'ai'
require 'net-client'
require 'scoreboard'
require 'announcer'
require 'screentip'

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
STATE = 'play'

HOST = "localhost"
PORT = 8989

function love.load()

	love.window.setTitle(TITLE)
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

	ball = Ball.create(SCREEN_WIDTH / 2 , 250, SCREEN_WIDTH, SCREEN_HEIGHT)
	paddle1 = Paddle.create(1, 15, SCREEN_HEIGHT, 'w', 's')

	scoreboard = Scoreboard.create(PLAYER_1, PLAYER_2, ((SCREEN_WIDTH / 2) - 50), 25)
	announcer = Announcer.create(((SCREEN_WIDTH / 2) - 45), 130)
	screentip = Screentip.create(((SCREEN_WIDTH / 2) - 30), 200)

	if PLAY_AI then 
		playAI()
	else
		playHuman()
	end

	ball:setDirection(1, 1)
end

function playAI()
	PLAYER_2 = "COM"
	ai = AI.create(2, (SCREEN_WIDTH - 35), SCREEN_WIDTH, SCREEN_HEIGHT)
end

function playHuman()
	PLAYER_2 = "P2"
	paddle2 = Paddle.create(2, (SCREEN_WIDTH - 35), SCREEN_HEIGHT, 'up', 'down')
end

function love.update(dt)
	if STATE ~= 'play' then
		return
	end

	if GAME_ACTIVE then
		ball:update(dt)
		paddle1:update(dt)	
		ball:hitA(paddle1)
		if PLAY_AI then
			ai:update(dt, ball)
			ball:hitB(ai)
		else
			paddle2:update(dt)
			ball:hitB(paddle2)
		end
		
		SCORE_PLAYER_2 = ball:scoreA()
		SCORE_PLAYER_1 = ball:scoreB()
		ball:bounce()
		checkScore()
	end
end

function love.draw()
	if GAME_ACTIVE then
		ball:draw()
		paddle1:draw()
		if PLAY_AI then
			ai:draw()
		else
			paddle2:draw()
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
		PLAYER_2 = "P2"
		setupGame()
	elseif GAME_READY and key == '2' then
		PLAY_AI = true
		PLAYER_2 = "COM"
		setupGame()
	elseif GAME_ACTIVE and key == 'p' then
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
	screentip:draw("Select opponent", "(1) Human\t\t\t(2) Computer")
end

function setupGame()
	GAME_READY = false
	GAME_ACTIVE = true
	STATE = 'play'
	SCORE_PLAYER_1 = 0
	SCORE_PLAYER_2 = 0
	love.load()
end
