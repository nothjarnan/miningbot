turtle.digDown()
turtle.down()

local forward = true 

function turnAround()
    if forward then 
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
    forward = not forward
end

function digLine(len)
    for x = 1, len do 
        turtle.dig()
        turtle.forward()        
    end
end

local width = 3 

--# Räkna block typ
--# remaininblocks-1 (per line)
--# nollställ efter digline
for x = 1, width do 
    if x > 1 then 
        digLine(2)
    else 
        digLine(3)    
    end
    if x ~= width then 
        turnAround()
    end
end

