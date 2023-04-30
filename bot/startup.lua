local fuelLevel = turtle.getFuelLevel()
local maxLevel = turtle.getFuelLimit()

function needsFuel(moveDistance) 
    fuelLevel = turtle.getFuelLevel()
    if moveDistance ~= nil then 
        if fuelLevel-moveDistance <= 0 then 
            return true
        end
    else 
        if fuelLevel-1 <= 0 then 
            return true 
        end
    end
    return false
end


function mine(xWidth, zWidth, depth)
    -- Begin by mining block underneath
    turtle.digDown()
    turtle.down()
    for layer=1, depth, 1 do 
        for fwd=1, zWidth, 1 do 
            turtle.dig()
            turtle.forward()
        end
    end
end
print("minebot")
mine(3,3,3)