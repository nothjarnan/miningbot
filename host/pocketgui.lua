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
            return true
        end
        if recv_id == id and message == "err=turtle_already_claimed" then 
            print("Could not claim turtle")
            return false 
        end
    end
end

function gui() 

end

function control() 

end

print("Enter turtle id to attempt to claim!")
local attemptId = read()

if claimTurtle(tonumber(attemptId)) then 
    -- proceed to program
    shell.run("clear")

end
