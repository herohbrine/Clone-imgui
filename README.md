# lgui
lgui is a gui for love2d made with 100% lua

**Code Examples**

    local gui = require("scripts.lgui.lgui")
    
    local i = 0
    local i2 = false
    
    function love.load()
    
        local font = love.graphics.newFont("assets/font.ttf", 64)
        love.graphics.setFont(font)
    
        love.window.setMode(0, 0, {
            fullscreen = true,
            resizable = true
        })
    
        window1 = gui.newWindow("My Window", 200, 200, 200, 200)
        window2 = gui.newWindow("The Other Window", 400, 400, 200, 150)
        window3 = gui.newWindow("My Window", 200, 400, 200, 200)
        window4 = gui.newWindow("The Other Window", 200, 400, 200, 150)
    
        label1 = window1:label(i, 5, 5)
        label2 = window2:label(i2, 5, 5)
    
        checkbox1 = window2:checkbox(window2, "title", 5, 30, true, function(state)
            i2 = tostring(state)
            label2:setTitle(i2)
        end)
    
        slider1 = window1:slider(window1, "i", 5, 30, i, function(value)
            i = value
        end)
    
    end
    
    function love.textinput(text)
        
        gui.textinput(text)
    
    end
    
    function love.keypressed(k)
        
        gui.keypressed(k)
    
    end
    
    function love.update(dt)
    
        gui.tick()
        label1:setTitle(i)
    
    end
    
    function love.draw()
    
        gui.draw()
    
    end

<img width="281" height="279" alt="thing" src="https://github.com/user-attachments/assets/8d63d471-a6df-4439-9e0e-12bd14d296a2" />

