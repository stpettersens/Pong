-- Pong game
-- Copyright (c) 2014 Sam Saint-Pettersen
-- Powered by LÖVE Game Engine

require 'ball'
require 'paddle'
require 'scoreboard'
require 'announcer'

TITLE = "Pong"
SCREEN_WIDTH = 700
SCREEN_HEIGHT = 500
WINNING_SCORE = 10
SCORE_PLAYER_1 = 0
SCORE_PLAYER_2 = 0
GAME_ACTIVE = true
STATE = 'play'


function love.load()
	love.window.setTitle(TITLE)
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

	ball = Ball.create(SCREEN_WIDTH / 2 , 250, SCREEN_WIDTH, SCREEN_HEIGHT)
	paddle1 = Paddle.create(1, 15, SCREEN_HEIGHT, 'w', 's')
	paddle2 = Paddle.create(2, (SCREEN_WIDTH - 35), SCREEN_HEIGHT, 'up', 'down')
	scoreboard = Scoreboard.create((SCREEN_WIDTH / 2), 25)
	announcer = Announcer.create((SCREEN_WIDTH / 2), 150)
end

function love.update(dt)
	if STATE ~= 'play' then
		return
	end

	if GAME_ACTIVE then
		paddle1:update(dt)
		paddle2:update(dt)
		ball:update(dt)
		ball:hitA(paddle1)
		ball:hitB(paddle2)
		SCORE_PLAYER_2 = ball:scoreA()
		SCORE_PLAYER_1 = ball:scoreB()
		ball:bounce()
		checkScore()
	end
end

function love.draw()
	if GAME_ACTIVE then
		paddle1:draw()
		paddle2:draw()
		ball:draw()
		scoreboard:draw(SCORE_PLAYER_1, SCORE_PLAYER_2)
	else
		local player = 0
		local score = 0
		if SCORE_PLAYER_1 > SCORE_PLAYER_2 then
			player = 1
			score = SCORE_PLAYER_1

		elseif SCORE_PLAYER_2 > SCORE_PLAYER_1 then
			player = 2
			score = SCORE_PLAYER_2
		end
		announcer:draw(player, score)
	end
end


function love.keypressed(key)
	if key == 'p' then
		if STATE == 'play' then
			STATE = 'pause'
		else
			STATE = 'play'
		end
	end
end

function checkScore()
	if SCORE_PLAYER_1 == WINNING_SCORE 
	or SCORE_PLAYER_2 == WINNING_SCORE then
		GAME_ACTIVE = false
	end
end
