-- För turtle
rednet.open("left")

local x = 0
local y = 0 
local z = 0
-- test
local instructions = 
{
    ["move_forward"] = turtle.forward,
    ["move_back"] = turtle.back,
    ["move_up"] = turtle.up,
    ["move_down"] = turtle.down,
    ["dig"] = turtle.dig,
    ["dig_down"] = turtle.digDown,
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
        local id, message = rednet.receive() 
        print("Decoding instructions")
        local instructionTable = decodeInstructionsToTable(message)
        if id ~= 6 then 
            instructionTable = {}
            print("Invalid source - no instructions decoded")
        end
        print("Adding decoded instructions to queue")
        for k,v in ipairs(instructionTable) do
            print(k..","..v) 
            table.insert(instructionList, v)
        end
        sleep(0)
    end
end

function instructionWatchdog() 
    while true do
        if #instructionList > 0 then 
            print("Instructions left " .. #instructionList)
            instructions[instructionList[1]]()
            table.remove(instructionList, 1)
        end
        sleep(0.5)
    end
end

function decodeInstructionsToTable(instructionString)
    local t = split(instructionString, ",")
    return t
end
parallel.waitForAny(instructionWatchdog, listen)



