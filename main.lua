local paddle_speed = 400
local initial_ball_speed = 300
local ball_speed_increment = 50
local paddle_width, paddle_height = 20, 100
local ball_size = 20
local winning_score = 5

local player1_y, player2_y
local ball_x, ball_y, ball_dx, ball_dy
local player1_score, player2_score
local is_game_over, is_paused, show_title_screen
local ai_difficulty = 1

function love.load()
    love.window.setTitle("Advanced Tennis Game")
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    player1_y = (love.graphics.getHeight() - paddle_height) / 2
    player2_y = (love.graphics.getHeight() - paddle_height) / 2
    reset_ball()
    player1_score = 0
    player2_score = 0
    is_game_over = false
    is_paused = false
    show_title_screen = true
end

function reset_ball()
    ball_x = love.graphics.getWidth() / 2 - ball_size / 2
    ball_y = love.graphics.getHeight() / 2 - ball_size / 2
    ball_dx = initial_ball_speed * (math.random(2) == 1 and 1 or -1)
    ball_dy = initial_ball_speed * (math.random(2) == 1 and 1 or -1)
end

function love.update(dt)
    if show_title_screen then
        if love.keyboard.isDown("return") then
            show_title_screen = false
        end
        return
    end

    if is_paused then
        if love.keyboard.isDown("p") then
            is_paused = false
        end
        return
    end

    if is_game_over then
        if love.keyboard.isDown("space") then
            player1_score = 0
            player2_score = 0
            is_game_over = false
            reset_ball()
        end
        return
    end

    if love.keyboard.isDown("p") then
        is_paused = true
    end

    if love.keyboard.isDown("w") then
        player1_y = math.max(0, player1_y - paddle_speed * dt)
    elseif love.keyboard.isDown("s") then
        player1_y = math.min(love.graphics.getHeight() - paddle_height, player1_y + paddle_speed * dt)
    end

    if ball_y + ball_size / 2 < player2_y + paddle_height / 2 then
        player2_y = math.max(0, player2_y - paddle_speed * dt * ai_difficulty)
    elseif ball_y + ball_size / 2 > player2_y + paddle_height / 2 then
        player2_y = math.min(love.graphics.getHeight() - paddle_height, player2_y + paddle_speed * dt * ai_difficulty)
    end

    ball_x = ball_x + ball_dx * dt
    ball_y = ball_y + ball_dy * dt

    if ball_y <= 0 or ball_y + ball_size >= love.graphics.getHeight() then
        ball_dy = -ball_dy
    end

    if ball_x <= paddle_width and ball_y + ball_size >= player1_y and ball_y <= player1_y + paddle_height then
        ball_dx = -ball_dx
        ball_dx = ball_dx - ball_speed_increment
        ball_dy = ball_dy + (ball_y + ball_size / 2 - player1_y - paddle_height / 2) * 5
    end

    if ball_x + ball_size >= love.graphics.getWidth() - paddle_width and ball_y + ball_size >= player2_y and ball_y <= player2_y + paddle_height then
        ball_dx = -ball_dx
        ball_dx = ball_dx + ball_speed_increment
        ball_dy = ball_dy + (ball_y + ball_size / 2 - player2_y - paddle_height / 2) * 5
    end

    if ball_x < 0 then
        player2_score = player2_score + 1
        reset_ball()
    end

    if ball_x > love.graphics.getWidth() then
        player1_score = player1_score + 1
        reset_ball()
    end

    if player1_score >= winning_score or player2_score >= winning_score then
        is_game_over = true
    end
end

function love.draw()
    if show_title_screen then
        love.graphics.printf("Welcome to Advanced Tennis Game\nPress Enter to Start\nW/S to move, P to pause", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
        return
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, player1_y, paddle_width, paddle_height)
    love.graphics.rectangle("fill", love.graphics.getWidth() - paddle_width, player2_y, paddle_width, paddle_height)
    love.graphics.rectangle("fill", ball_x, ball_y, ball_size, ball_size)
    love.graphics.print("Player 1: " .. player1_score, 10, 10)
    love.graphics.print("Player 2: " .. player2_score, love.graphics.getWidth() - 100, 10)

    if is_game_over then
        love.graphics.printf("Game Over! Press Space to Restart", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end

    if is_paused then
        love.graphics.printf("Paused - Press P to Resume", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), "center")
    end
end
