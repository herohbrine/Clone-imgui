require "scripts.utils"

local m = {}

function m.new(title, x, y)

    local label = {}

    local font = love.graphics.getFont()

    label.type = "label"
    label.title = title or "label"
    label.x = x or 0
    label.y = y or 0
    label.w = font:getWidth(tostring(label.title))*(1/text.scale)
    label.h = font:getHeight()/text.scale

    function label:setTitle(title)

        if title == self.title then return end

        self.title = tostring(title)
        self.w = font:getWidth(self.title)/text.scale
    end

    return label
end

function m.draw(win)

    if not win.labels then return end

    for _, label in ipairs(win.labels) do

        love.graphics.print(label.title, label.x + win.x, label.y + win.y, 0, 1/text.scale)

    end
end

return m