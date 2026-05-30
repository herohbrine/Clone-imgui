require "modules.utils"

local m = {}

function m.new(title, x, y, callback)

    local but = {}

    local font = love.graphics.getFont()

    but.type = "button"
    but.title = title or "button"
    but.x = x or 0
    but.y = y or 0
    but.w = (font:getWidth(but.title)/text.scale)+4
    but.h = (font:getHeight()/text.scale)+4

    but.hover = false
    but.active = false
    but.pressed = false

    but.callback = callback

    function but:setX(x) 
        but.x = x
    end

    return but
end

function m.tick(win, mouse)

    if not win.buttons then return end

    for _, but in ipairs(win.buttons) do

        local bx = win.x + but.x
        local by = win.y + but.y

        local wx = win.x
        local wy = win.y
        local ww = win.w
        local wh = win.h

        local x1 = math.max(bx, wx)
        local y1 = math.max(by, wy)

        local x2 = math.min(bx + but.w, wx + ww)
        local y2 = math.min(by + but.h, wy + wh)

        local box = {
            x = x1,
            y = y1,
            w = math.max(0, x2 - x1),
            h = math.max(0, y2 - y1)
        }

        but.hover = collision.pointInRect(box, mouse)

        but.pressed = false

        if but.hover and mouse.down and not mouse.lastMouseDown then
            but.pressed = true

            if but.callback then
                but.callback()
            end
        end

        but.active = but.hover and mouse.down
    end
end

function m.draw(win)

    if not win.buttons then return end

    for _, but in ipairs(win.buttons) do

        local bx = win.x + but.x
        local by = win.y + but.y

        if but.active then
            love.graphics.setColor(.1, .1, .7, 1)
        elseif but.hover then
            love.graphics.setColor(.3, .3, 1, 1)
        else
            love.graphics.setColor(.2, .2, .8, 1)
        end

        love.graphics.rectangle("fill", bx, by, but.w, but.h)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(but.title, bx+2, by+2, 0, 1/text.scale)

    end
end

return m