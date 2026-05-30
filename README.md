# Clone-imgui
Clone imgui is a ripoff of Dear imgui made in 100% lua with love 2d

**Code Examples**

    local wm = require("modules.wm.wm")
    
    local i = 0
    
    function love.load()
    
        local font = love.graphics.newFont("assets/font.ttf", 64)
        love.graphics.setFont(font)
    
        love.window.setMode(0, 0, {
            fullscreen = true,
            resizable = true
        })
    
        window1 = wm.newWindow("My Window", 200, 200, 200, 200)
    
        label1 = window1:label(i, 5, 5)
    
        slider1 = window1:slider(window1, "i", 5, 30, i, function(value)
            i = value
        end)
    
    end
    
    function love.textinput(text)
        
        wm.textinput(text)
    
    end
    
    function love.keypressed(k)
        
        wm.keypressed(k)
    
    end
    
    function love.update(dt)
    
        wm.tick()
        label1:setTitle(i)
    
    end
    
    function love.draw()
    
        wm.draw()
    
    end

<img width="281" height="279" alt="thing" src="https://github.com/user-attachments/assets/8d63d471-a6df-4439-9e0e-12bd14d296a2" />

