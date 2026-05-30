require "modules.utils"

button = require("modules.wm.button")
label = require("modules.wm.label")
textbox = require("modules.wm.input")
slider = require("modules.wm.slider")
checkbox = require("modules.wm.checkbox")

local wm = {}
wm.__index = wm

local event = {}
local windows = {}

local curWin = nil

local mouse = {x = 0, y = 0, down = false, lastMouseDown = false} 

local function findID(i)
    local id = i or 1

    for _, win in ipairs(windows) do
        if id == win.id then
            return findID(id + 1)
        end
    end

    return id
end

function event.move(win, mouse)

    local title = {x = win.x, y = win.y-20, w = win.w, h = 20}
    local conditions = (not win.resizing and not mouse.lastMouseDown and (curWin == win.id or curWin == nil))

    if collision.pointInRect(title, mouse) and mouse.down and conditions then   
        if win.dragging == false then
            win.dragging = true

            win.startX = win.x - mouse.x
            win.startY = win.y - mouse.y
        end
    else
        if not mouse.down and win.dragging then
            win.dragging = false

            win.startX = 0
            win.startY = 0
        end
    end

    if win.dragging == true then
        win.x = (win.startX + mouse.x)
        win.y = (win.startY + mouse.y)
    end
end

function event.resize(win, mouse)

    local tri = {x = (win.x+win.w)-20, y = (win.y+win.h)-20, w = 20, h = 20}
    local conditions = (not win.dragging and not mouse.lastMouseDown and (curWin == win.id or curWin == nil))

    if collision.pointInRect(tri, mouse) and mouse.down and conditions then
        if win.resizing == false then
            win.resizing = true

            win.startX = win.w - mouse.x
            win.startY = win.h - mouse.y
        end
    else
        if not mouse.down and win.resizing then
            win.resizing = false

            win.startX = 0
            win.startY = 0

        end
    end

    if win.resizing == true then
        win.w = (win.startX + mouse.x)
        win.h = (win.startY + mouse.y)

        win.w = math.max(win.w, 150)
        win.h = math.max(win.h, 150)
    end
end

function wm.newWindow(title, x, y, w, h)

    local win = setmetatable({}, self)

    win.title = title or "new window"
    win.id = findID()
    win.dragging = false
    win.resizing = false

    win.x = x or 0
    win.y = y or 0

    win.startX = nil
    win.startY = nil

    win.w = w or 100
    win.h = h or 100

    win.close = {}
    win.close.hover = false
    win.close.active = false
    local font = love.graphics.getFont()
    win.close.w = font:getWidth('x')/text.scale
    win.close.h = font:getHeight()/text.scale

    win.buttons = {}
    win.labels = {}
    win.inputs = {}
    win.sliders = {}
    win.checkboxes = {}
    

    table.insert(windows, win)

    function win:button(title, x, y, callback)

        local b = button.new(title, x, y, callback)
        table.insert(self.buttons, b)
        return b

    end

    function win:label(title, x, y)
    
        local l = label.new(title, x, y)
        table.insert(self.labels, l)
        return l
    
    end

    function win:textbox(title, x, y, callback)
    
        local tb = textbox.new(title, x, y, callback)
        table.insert(self.inputs, tb)
        return tb
    
    end

    function win:slider(win, title, x, y, value, callback)
    
        local s = slider.new(win, title, x, y, value, callback)
        table.insert(self.sliders, s)
        return s
    
    end

    function win:checkbox(win, title, x, y, state, callback)
        
        local cb = checkbox.new(win, title, x, y, state, callback)
        table.insert(self.checkboxes, cb)
        return cb 

    end

    return win
end

function wm.textinput(text)
    
    for i, win in ipairs(windows) do 

        local active = (curWin == nil or curWin == win.id)

        if active then 
            
            textbox.textinput(text, win)

        end
    end
end

function wm.keypressed(k)
    
    for i, win in ipairs(windows) do 

        local active = (curWin == nil or curWin == win.id)

        if active then 
            
            textbox.keypressed(k, win)

        end
    end
end

function wm.tick(dt)

    local noSelectedWins = 0
    local mx, my = love.mouse.getPosition()
    mouse.x, mouse.y = mx, my
    mouse.down = love.mouse.isDown(1)

    curWin = nil
    for i = #windows, 1, -1 do
        local win = windows[i]

        local box = {x = win.x, y = win.y-20, w = win.w, h = win.h+20}

        if mouse.down and collision.pointInRect(box, mouse) and not mouse.lastMouseDown then
            curWin = win.id

            table.remove(windows, i)
            table.insert(windows, win)

            break
        end

        if win.close.active and not mouse.down then 
            table.remove(windows, i)
        end
    end

    for i, win in ipairs(windows) do

        local active = (curWin == nil or curWin == win.id)

        if active then
            event.move(win, mouse)
            event.resize(win, mouse)

            win.close.box = {x = (win.x+win.h)-20, y = win.y-20, w = 20, h = 20}
            win.close.hover = collision.pointInRect(win.close.box, mouse)
            win.close.active = win.close.hover and mouse.down

            button.tick(win, mouse)
            textbox.tick(win, mouse)
            slider.tick(win, mouse)
            checkbox.tick(win, mouse)
        end

        if mouse.down then
            mouse.downBefore = true
        else
            mouse.downBefore = false
        end
    end

    mouse.lastMouseDown = mouse.down

end

function wm.draw()
    for i, win in ipairs(windows) do
        
        love.graphics.setScissor(win.x, win.y-20, win.w, win.h+20)
        love.graphics.setColor(.2, .2, .8, 1)
        love.graphics.rectangle("fill", win.x, win.y-20, win.w, 20)
        love.graphics.setColor(.2, .2, .25, 1)
        love.graphics.rectangle("fill", win.x, win.y, win.w, win.h)

        if win.close.active then
            love.graphics.setColor(.1, .1, .7, 1)
        else
            if win.close.hover == true then
                love.graphics.setColor(.3, .3, .9, 1)
            else 
                love.graphics.setColor(.2, .2, .8, 1)
            end
        end
        love.graphics.rectangle("fill", (win.x+win.w)-20, win.y-20, 20, 20)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("x", ((win.x+win.w)-10)-((win.close.w/2)), (win.y-10)-(win.close.h/2), 0, 1/text.scale)
        love.graphics.print(win.title, win.x+5, win.y-17, 0, 1/text.scale)

        button.draw(win)
        label.draw(win)
        textbox.draw(win)
        slider.draw(win)
        checkbox.draw(win)

        love.graphics.setColor(.2, .2, .4, 1)
        love.graphics.polygon("fill", (win.x+win.w), (win.y+win.h), (win.x+win.w), (win.y+win.h)-20, (win.x+win.w)-20, (win.y+win.h))

        love.graphics.setScissor()

    end
end

return wm