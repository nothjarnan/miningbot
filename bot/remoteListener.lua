-- För turtle
rednet.open("right")

local x = 0
local y = 0 
local z = 0
-- test
local instructions = 
{
    ["move_forward"] = turtle.forward,
    ["dig"] = turtle.dig,
    ["dig_down"] = turtle.digDown,
    ["turn_right"] = turtle.turnRight,
    ["turn_left"] = turtle.turnLeft,
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
        local instructionTable = decodeInstructionsToTable(message)
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



