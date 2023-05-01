local attachedPeripherals = peripheral.getNames()


local tArgs = {...}
local turtle = -1
function claimTurtle(id)
    id = tonumber(id) 
    print("Claiming turtle #"..id)
    rednet.broadcast("claim#"..id)
    print("Awaiting turtle reply")
    while true do 
        local recv_id, message = rednet.receive()
        
        if recv_id == id and (message == "turtle_claim_success" or message=="turtle_owned_by_you")  then 
            turtle = tonumber(id)
            print("Success!")
            return true
        end
        if recv_id == id and message == "err=turtle_already_claimed" then 
            print("Could not claim turtle")
            return false 
        end
    end
end
function sendInstructionAwait(instruction) 
    rednet.send(tonumber(turtle), instruction)
    local id, message = rednet.receive()
    if id == turtle then 
        if message == "ins_fin" then 
            print("Continuing with next instruction")
        end
        if message == "err=obstruction_fwd" then
            sendInstructionAwait("dig")
        end
        if message == "err=obstruction_down" then 
            sendInstructionAwait("dig_down")
        end
        if message == "err=obstruction_up" then 
            sendInstructionAwait("dig_up")
        end
    end
end
function sendDigLayer(xw, zw)
    for x = 0, xw do 
        for z = 0, zw do 

        end
    end
end
function digDown()
    sendInstructionAwait("dig_down")
    sendInstructionAwait("move_down")
end

function stripMine(iterations_x, tunnelDepth)
    local tunnelSpacing = 5
    for x = 1, iterations_x do
        print("Digging tunnel") 
        sendDigTunnel(3, 3, tunnelDepth)
        print("Returning")
        sendInstructionAwait("turn_left,turn_left")
        for z = 1, tunnelDepth do 
            if z < tunnelDepth then 
                sendInstructionAwait("move_forward")
            end
        end
        sendInstructionAwait("turn_right")
        for sp = 1, tunnelSpacing do 
            if sp < tunnelSpacing then 
                sendInstructionAwait("move_forward")
            end
        end
        sendInstructionAwait("turn_left,turn_left")
    end
end

function sendDigTunnel(width, height, length)
    print(width, height, length)
    sendInstructionAwait("dig")
    for z = 1, length do 
        for x = 1, width do 
            -- dig one column            
            for y = 1, height do 
                sendInstructionAwait("dig")
                if y < height then 
                    sendInstructionAwait("move_up")
                end
            end
            -- go down again
            for down=1, height do 
                if down < height then 
                    sendInstructionAwait("move_down")
                end
            end
            if x < width then 
                sendInstructionAwait("turn_right")
                sendInstructionAwait("move_forward")
                sendInstructionAwait("turn_left")
            end       
        end
        sendInstructionAwait("turn_left")
        for left=1, width do
            if left < width then 
                sendInstructionAwait("move_forward")
            end
        end
        sendInstructionAwait("turn_right")
        sendInstructionAwait("move_forward")
    end
    
end

if #tArgs == 5 then
    print("Input args ok")
    print("Finding modem")
    local hasModem = false
    for k,v in ipairs(attachedPeripherals) do 
        if peripheral.getType(v) == "modem" then 
            rednet.open(attachedPeripherals[k])
            hasModem = true
        end
    end 
    if hasModem then 
        print("Modem found and opened")
        if claimTurtle(tArgs[2]) then 
            print("Turtle claim ok")
            turtle = tArgs[2]
            if tArgs[1] == "hole" then 
                sendDigLayer(tArgs[3], tArgs[4])
            elseif tArgs[1] == "tunnel" then 
                sendDigTunnel(tonumber(tArgs[3]), tonumber(tArgs[4]), tonumber(tArgs[5]))
            elseif tArgs[1] == "stripmine" then 
                stripMine(tonumber(tArgs[3]), tonumber(tArgs[4]))
            end
        
        else 
            print("Turtle claim not ok, aborting")
        end
    else 
        print("No modem attached, aborting")
    end
    
    -- targs 1 = id 
    -- targs 2 = widthx
    -- targs 3 = widthz 
    -- targs 4 = depth

end

