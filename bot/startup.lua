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
    local forward = true
    
    for layer=1, depth, 1 do 
        turtle.digDown()
        turtle.down()
        for right=1, xWidth-1, 1 do 
            for fwd=1, zWidth-1, 1 do 
                turtle.dig()
                turtle.forward()
                print("dig forward")
                print(fwd, zWidth)
            end
            print(right, xWidth)
            if forward then 
                print(forward)
                turtle.turnRight()
                turtle.dig()
                turtle.forward()
                turtle.turnRight()
            else 
                turtle.turnLeft()
                turtle.dig()
                turtle.forward()
                turtle.turnLeft()
            end
            turtle.dig()
            forward = not forward
        end
        print("returning")
        break
        -- return 
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward(zWidth-1)
        turtle.turnRight()
        turtle.forward(xWidth-1)
        turtle.turnRight()
        -- back to square 1
    end
    -- return to surface
    for layer=1, depth-1, 1 do 
        turtle.up()
    end
    print("test")
end
print("minebot")
mine(3,3,3)