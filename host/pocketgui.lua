rednet.open("back")

local logs = {}
local claimedTurtle = 0

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

function control() 
    while true do 
        local event, key, isHeld = os.pullEvent("key")
        print(key)
    end
    gui()

end

print("Enter turtle id to attempt to claim!")
local attemptId = read()

if claimTurtle(tonumber(attemptId)) then 
    -- proceed to program
    parallel.waitForAny(control, turtleSignalListener)
end
