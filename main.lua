local paddle_speed = 400
local ball_speed = 300
local paddle_width, paddle_height = 20, 100
local ball_size = 20

local player1_y, player2_y
local ball_x, ball_y, ball_dx, ball_dy
local player1_score, player2_score

function love.load()
    love.window.setTitle("Tennis Game")
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    player1_y = (love.graphics.getHeight() - paddle_height) / 2
    player2_y = (love.graphics.getHeight() - paddle_height) / 2
    reset_ball()
    player1_score = 0
    player2_score = 0
end

function reset_ball()
    ball_x = love.graphics.getWidth() / 2 - ball_size / 2
    ball_y = love.graphics.getHeight() / 2 - ball_size / 2
    ball_dx = ball_speed * (math.random(2) == 1 and 1 or -1)
    ball_dy = ball_speed * (math.random(2) == 1 and 1 or -1)
end

function love.update(dt)
    if love.keyboard.isDown("w") then
        player1_y = math.max(0, player1_y - paddle_speed * dt)
    elseif love.keyboard.isDown("s") then
        player1_y = math.min(love.graphics.getHeight() - paddle_height, player1_y + paddle_speed * dt)
    end

    if love.keyboard.isDown("up") then
        player2_y = math.max(0, player2_y - paddle_speed * dt)
    elseif love.keyboard.isDown("down") then
        player2_y = math.min(love.graphics.getHeight() - paddle_height, player2_y + paddle_speed * dt)
    end

    ball_x = ball_x + ball_dx * dt
    ball_y = ball_y + ball_dy * dt

    if ball_y <= 0 or ball_y + ball_size >= love.graphics.getHeight() then
        ball_dy = -ball_dy
    end

    if ball_x <= paddle_width and ball_y + ball_size >= player1_y and ball_y <= player1_y + paddle_height then
        ball_dx = -ball_dx
        ball_x = paddle_width
    end

    if ball_x + ball_size >= love.graphics.getWidth() - paddle_width and ball_y + ball_size >= player2_y and ball_y <= player2_y + paddle_height then
        ball_dx = -ball_dx
        ball_x = love.graphics.getWidth() - paddle_width - ball_size
    end

    if ball_x < 0 then
        player2_score = player2_score + 1
        reset_ball()
    end

    if ball_x > love.graphics.getWidth() then
        player1_score = player1_score + 1
        reset_ball()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, player1_y, paddle_width, paddle_height)
    love.graphics.rectangle("fill", love.graphics.getWidth() - paddle_width, player2_y, paddle_width, paddle_height)
    love.graphics.rectangle("fill", ball_x, ball_y, ball_size, ball_size)
    love.graphics.print("Player 1: " .. player1_score, 10, 10)
    love.graphics.print("Player 2: " .. player2_score, love.graphics.getWidth() - 100, 10)
end
