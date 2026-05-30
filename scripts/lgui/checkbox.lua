require "scripts.utils"

local label = require("scripts.lgui.label")

local m = {}

function m.new(win, title, x, y, state, callback)
    
    local cb = {}

    cb.title = title or "checkbox"
    cb.x = x or 0
    cb.y = y or 0
    cb.state = state or false

    cb.h = 12
    cb.w = 12

    cb.hover = false

    cb.callback = callback

    local font = love.graphics.getFont()

    cb.callback(cb.state)

    cb.name = label.new(cb.title, x + cb.w + 4, y)
    table.insert(win.labels, cb.name)

    return cb

end

function m.tick(win, mouse)
    
    if not win.checkboxes then return end

    for _, cb in ipairs(win.checkboxes) do 
        
        local cbx = win.x + cb.x
        local cby = win.y + cb.y
        
        local wx = win.x
        local wy = win.y
        local ww = win.w
        local wh = win.h
        
        local x1 = math.max(cbx, wx)
        local y1 = math.max(cby, wy)
        
        local x2 = math.min(cbx + cb.w, wx + ww)
        local y2 = math.min(cby + cb.h, wy + wh)
        
        local box = {
            x = x1,
            y = y1,
            w = math.max(0, x2 - x1),
            h = math.max(0, y2 - y1)
        }

        cb.hover = collision.pointInRect(box, mouse)

        if cb.hover and mouse.down and not mouse.lastMouseDown then 
            if cb.state then 
                cb.state = false
            else 
                cb.state = true
            end
            cb.callback(cb.state)
        end

    end
end

function m.draw(win)

    if not win.checkboxes then return end

    for _, cb in ipairs(win.checkboxes) do 
        
        if cb.hover then
            love.graphics.setColor(.4, .4, .6, 1)
        else 
            love.graphics.setColor(.3, .3, .5, 1)
        end

        local cbx = win.x + cb.x
        local cby = win.y + cb.y

        love.graphics.rectangle("fill", cbx, cby, cb.w, cb.h)

        if cb.state then 
            if cb.hover then
                love.graphics.setColor(.4, .4, 1, 1)
            else 
                love.graphics.setColor(.3, .3, .9, 1)
            end

            love.graphics.rectangle("fill", cbx+2, cby+2, cb.w-4, cb.h-4)

        end

    end
end

return m