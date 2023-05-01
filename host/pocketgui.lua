rednet.open("back")

local logs = {}
local claimedTurtle = 0

local instructionMapping = 
{
    ["17"] = "move_forward",
    ["31"] = "move_back",
    ["30"] = "turn_left",
    ["32"] = "turn_right",
    ["16"] = "move_up",
    ["18"] = "move_down",
    ["19"] = "refuel",
    ["33"] = "dig"
}

function claimTurtle(id) 
    rednet.broadcast("claim#"..id)
    print("Awaiting turtle reply")
    while true do 
        local recv_id, message = rednet.receive()
        if recv_id == id and (message == "turtle_claim_success" or message=="turtle_owned_by_you")  then 
            claimedTurtle = id
            print("Success!")
            return true
        end
        if recv_id == id and message == "err=turtle_already_claimed" then 
            print("Could not claim turtle")
            return false 
        end
    end
end

function gui() 
    shell.run("clear")
    for k,v in ipairs(logs) do 
        print(k,v)
    end
end

function turtleSignalListener() 
    while true do 
        local recv_id, message = rednet.receive()
        if recv_id == claimedTurtle then 
            table.insert(logs, message)
        end
        sleep(0)
    end
end

function sendInstruction(id, key)
    if instructionMapping[tostring(key)] ~= nil then 
        rednet.send(id, instructionMapping[tostring(key)])
    end
end

function control() 
    while true do 
        local event, key, isHeld = os.pullEvent("key")
        sendInstruction(claimedTurtle, key)
        gui()
    end

end

print("Enter turtle id to attempt to claim!")
local attemptId = read()

if claimTurtle(tonumber(attemptId)) then 
    -- proceed to program
    parallel.waitForAny(control, turtleSignalListener)
end
