-- För turtle
rednet.open("left")

local x = 0
local y = 0 
local z = 0

local senderId = -1

-- test
local instructions = 
{
    ["move_forward"] = function() if turtle.getFuelLevel() > 0 then turtle.forward() else rednet.send(senderId, "err=nofuel") end,
    ["move_back"] = turtle.back,
    ["move_up"] = turtle.up,
    ["move_down"] = turtle.down,
    ["dig"] = turtle.dig,
    ["dig_down"] = turtle.digDown,
    ["dig_up"] = turtle.digUp,
    ["turn_right"] = turtle.turnRight,
    ["turn_left"] = turtle.turnLeft,
    ["refuel"] = turtle.refuel,
}

local instructionList = {}

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end



function listen()
    while true do 
        print("Awaiting further instructions")
        local id, message = rednet.receive(5)
        if message ~= nil then 
            if senderId == -1 and message == "claim#"..os.getComputerID() then 
                senderId = id
                print("Turtle claimed by " .. id .. " until reboot")
                rednet.send(id, "turtle_claim_success")
            elseif message == "claim#"..os.getComputerID() and senderId == id then 
                print("Turtle already claimed by this user")
                rednet.send(id, "turtle_owned_by_you")
            elseif message == "claim#"..os.getComputerID() then 
                -- Already claimed 
                print("Claim attempt detected - sending error")
                sendError(id, "turtle_already_claimed")
            end
            print("Decoding instructions")
            local instructionTable = decodeInstructionsToTable(message)
            if id ~= senderId then 
                instructionTable = {}
                print("Invalid source - no instructions decoded")
            end
            print("Adding decoded instructions to queue")
            for k,v in ipairs(instructionTable) do
                print(k..","..v) 
                table.insert(instructionList, v)
            end
        end       
        sleep(0)
    end
end
function sendInfo(id, infoMessage)
    rednet.send(id, "info="..infoMessage)
end

function sendError(id, errorMessage)
    rednet.send(id, "err="..errorMessage)
end

function sendDoneSignal()
    rednet.send(senderId,"ins_fin")
end

function instructionWatchdog() 
    while true do
        if #instructionList > 0 then
            if instructions[instructionList[1]] ~= nil then 
                instructions[instructionList[1]]()

                if #instructionList - 1 == 0 then
                    sendDoneSignal() 
                end
                table.remove(instructionList, 1)
            else 
                print("Invalid instruction detected, skipping")
                if #instructionList - 1 == 0 then
                    sendDoneSignal() 
                 end
                table.remove(instructionList, 1)
            end
            print("Instructions left " .. #instructionList)
        end
        sleep(0.5)
    end
end

function decodeInstructionsToTable(instructionString)
    local t = split(instructionString, ",")
    return t
end
parallel.waitForAny(instructionWatchdog, listen)



