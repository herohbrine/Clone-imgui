text = {}
text.scale = 3.5

collision = {}
function collision.pointInRect(a, b)

    return b.x > a.x and b.x < a.x + a.w and b.y > a.y and b.y < a.y + a.h

end

function key(k) 
    return love.keyboard.isDown(k)
end
