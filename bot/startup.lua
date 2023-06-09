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

function moveClearObstruction(amount) 
    local has_block, data = turtle.inspect()
    print(data)
    if has_block then 
        turtle.dig()
    end
    turtle.forward(amount)
end

function mine(xWidth, zWidth, depth)
    -- Begin by mining block underneath
    local forward = true
    
    for layer=1, depth, 1 do 
        turtle.digDown()
        turtle.down()
        for right=1, xWidth-1, 1 do 
            for fwd=1, zWidth, 1 do 
                turtle.dig()
                moveClearObstruction()
                print("dig forward")
                print(fwd, zWidth)
            end
            print(right, xWidth)
            if forward then 
                print(forward)
                turtle.turnRight()
                turtle.dig()
                moveClearObstruction()
                turtle.turnRight()
            else 
                turtle.turnLeft()
                turtle.dig()
                moveClearObstruction()
                turtle.turnLeft()
            end
            forward = not forward
        end
        print("returning")
        -- return 
        turtle.turnRight()
        turtle.turnRight()
        moveClearObstruction(zWidth-1)
        turtle.turnRight()
        moveClearObstruction(xWidth-1)
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