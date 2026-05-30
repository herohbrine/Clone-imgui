require "scripts.utils"

button = require("scripts.lgui.button")
label = require("scripts.lgui.label")
textbox = require("scripts.lgui.input")

local m = {}

function m.new(win, title, x, y, value, callback)

    local slider = {}

    slider.title = title or "slider"
    slider.x = x or 0
    slider.y = y or 0
    slider.value = value or 0

    slider.callback = callback

    local font = love.graphics.getFont()
    local plusWidth = (font:getWidth("+")*(1/text.scale))+6
    local minusWidth = (font:getWidth("+")*(1/text.scale))+6

    local inputBoxW = font:getWidth(tostring(slider.value))*(1/text.scale)+6
    slider.inputBox = textbox.new(slider.x, slider.y, inputBoxW, function(value)
        slider.value = value
        slider.inputBox:setValue(slider.value)
        inputBoxW = font:getWidth(tostring(slider.value))*(1/text.scale)+6
        slider.minus.x = (x + plusWidth + 4 + inputBoxW + 4) 
        slider.plus.x = (x + inputBoxW + 6) 
        slider.inputBox.w = inputBoxW 
        slider.title.x = x + plusWidth + 4 + inputBoxW + 4 + minusWidth + 4
        slider.callback(slider.value)
    end)
    table.insert(win.inputs, slider.inputBox)

    slider.plus = button.new("+", x + inputBoxW + 6, y, function()
        slider.value = slider.value + 1
        slider.inputBox:setValue(slider.value)
        inputBoxW = font:getWidth(tostring(slider.value))*(1/text.scale)+6
        slider.minus.x = (x + plusWidth + 4 + inputBoxW + 4) 
        slider.plus.x = (x + inputBoxW + 6) 
        slider.inputBox.w = inputBoxW 
        slider.title.x = x + plusWidth + 4 + inputBoxW + 4 + minusWidth + 4
        slider.callback(slider.value)
    end)
    table.insert(win.buttons, slider.plus)
    
    slider.minus = button.new("-", x + plusWidth + 4 + inputBoxW + 4, y, function()
        slider.value = slider.value - 1
        slider.inputBox:setValue(slider.value)
        inputBoxW = font:getWidth(tostring(slider.value))*(1/text.scale)+6
        slider.minus.x = (x + plusWidth + 4 + inputBoxW + 4) 
        slider.plus.x = (x + inputBoxW + 6) 
        slider.inputBox.w = inputBoxW
        slider.title.x = x + plusWidth + 4 + inputBoxW + 4 + minusWidth + 4
        slider.callback(slider.value)
    end)
    table.insert(win.buttons, slider.minus)

    slider.title = label.new(title, x + plusWidth + 4 + inputBoxW + 4 + minusWidth + 4, y+4)
    table.insert(win.labels, slider.title)

    slider.inputBox:setValue(slider.value)

    return slider

end

function m.tick(win, mouse)
    


end

function m.draw(win)
    


end

return m