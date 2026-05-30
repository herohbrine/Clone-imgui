require "modules.utils"

local m = {}

local focusedOnTextBox = false

function m.new(x, y, w, callback)

    local textbox = {}

    local font = love.graphics.getFont()

    textbox.type = "textbox"
    textbox.value = ""
    textbox.x = x or 0
    textbox.y = y or 0
    textbox.w = w or 45
    textbox.w = w+4 or 45+4
    textbox.h = (font:getHeight()/text.scale)+4

    textbox.hover = true
    textbox.active = false

    textbox.callback = callback

    function textbox:setValue(value)
    
        if value == self.value then return end
    
        self.value = tostring(value)
        self.w = (font:getWidth(self.value)*(1/text.scale)) + 6
    end

    textbox.cursor = #textbox.value

    return textbox
end

function m.tick(win, mouse)

    if not win.inputs then return end

    for _, textbox in ipairs(win.inputs) do

        local ix = win.x + textbox.x
        local iy = win.y + textbox.y

        local wx = win.x
        local wy = win.y
        local ww = win.w
        local wh = win.h

        local x1 = math.max(ix, wx)
        local y1 = math.max(iy, wy)

        local x2 = math.min(ix + textbox.w, wx + ww)
        local y2 = math.min(iy + textbox.h, wy + wh)

        local box = {
            x = x1,
            y = y1,
            w = math.max(0, x2 - x1),
            h = math.max(0, y2 - y1)
        }

        textbox.hover = collision.pointInRect(box, mouse)

        if textbox.active and mouse.down and not mouse.lastMouseDown then
            textbox.callback(textbox.value)
            textbox.active = false
            focusedOnTextBox = false
            textbox.cursor = #textbox.value - #textbox.value
        end

        if textbox.hover and mouse.down and not mouse.lastMouseDown and not focusedOnTextBox then
            textbox.active = true
            focusedOnTextBox = true
        end

        if textbox.active and key("return") then
            textbox.callback(textbox.value)
            textbox.active = false
            focusedOnTextBox = false
            textbox.cursor = #textbox.value - #textbox.value
        end
    end
end

function m.textinput(text, win)

    if not win.inputs then return end

    for _, input in ipairs(win.inputs) do

        if input.active then

            local pos = input.cursor or #input.value

            input.value =
                input.value:sub(1, pos) ..
                text ..
                input.value:sub(pos + 1)

            input.cursor = pos + #text
        end
    end
end

function m.keypressed(key, win)

    if not win.inputs then return end

    for _, input in ipairs(win.inputs) do

        if input.active then

            local pos = input.cursor or #input.value

            if key == "backspace" then
                if pos > 0 then
                    input.value =
                        input.value:sub(1, pos - 1) ..
                        input.value:sub(pos + 1)

                    input.cursor = pos - 1
                end
            end

            if key == "left" then
                input.cursor = math.max(0, pos - 1)
            end

            if key == "right" then
                input.cursor = math.min(#input.value, pos + 1)
            end
        end
    end
end

function m.draw(win)

    if not win.inputs then return end

    for _, textbox in ipairs(win.inputs) do

        local bx = win.x + textbox.x
        local by = win.y + textbox.y

        if textbox.active then
            love.graphics.setColor(.1, .1, .3, 1)
        elseif textbox.hover then
            love.graphics.setColor(.3, .3, .5, 1)
        else
            love.graphics.setColor(.2, .2, .4, 1)
        end

        love.graphics.rectangle("fill", bx, by, textbox.w, textbox.h)

        local font = love.graphics.getFont()
        local scale = 1 / text.scale

        textbox.scroll = textbox.scroll or 0

        local cursor = textbox.cursor or #textbox.value
        local textBefore = textbox.value:sub(1, cursor)

        local cursorX = font:getWidth(textBefore) * scale

        local padding = 3
        local visibleWidth = textbox.w - padding * 2

        if cursorX - textbox.scroll > visibleWidth then
            textbox.scroll = cursorX - visibleWidth
        end

        if cursorX - textbox.scroll < 0 then
            textbox.scroll = cursorX
        end

        love.graphics.setScissor(bx, by, textbox.w, textbox.h)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(
            textbox.value,
            bx + padding - textbox.scroll,
            by + padding,
            0,
            scale
        )

        if textbox.active then
            local cx = bx + padding + (cursorX - textbox.scroll)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.line(
                cx,
                by + padding,
                cx,
                by + textbox.h - padding
            )
        end

        love.graphics.setScissor()

    end
end

return m