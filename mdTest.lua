local handle = http.get("https://raw.githubusercontent.com/Apachedrag427/CC/main/mdTest.lua")
if handle then
    local current = fs.open(shell.getRunningProgram(), "w")
    if current and current.write then
        current.close()
	    current = fs.open(shell.getRunningProgram(), "r")
	    local contents = current.readAll()
	    current.close()
	    local updated = handle.readAll() ~= contents
	    if updated then
	    	local f = fs.open(shell.getRunningProgram(), "w")
	    	f.write(handle.readAll())
            f.close()
	    end
	    handle.close()
    end
end

local code = string.char(167)
local codes = {
    ["**"] = code .. "l",
    ["*"] = code .. "o",
    ["_"] = code .. "n",
    ["~~"] = code .. "m",
}
function string.cut(str, place1, place2, inclusive)
    local firstpart
    local secondpart
    if inclusive then
        firstpart = str:sub(1, place1 - 1)
        secondpart = str:sub(place2 + 1, #str)
    else
        firstpart = str:sub(1, place1)
        secondpart = str:sub(place2, #str)
    end
    return firstpart .. secondpart
end
function string.insert(str, place, value, replace)
    local firsthalf
    if replace then
        firsthalf = str:sub(1, place - 1)
    else
        firsthalf = str:sub(1, place)
    end
    local secondhalf = str:sub(place + 1, #str)
    return firsthalf .. value .. secondhalf
end

local chat = peripheral.wrap("top")
chat.capture("")
local pull = os.pullEvent
os.pullEvent = os.pullEventRaw
local function grab()
    local event, msg, _, plr, uuid = os.pullEvent()
    if event == "terminate" then return "terminated" elseif event ~= "chat_capture" then return end
    for k, v in pairs(codes) do
        if msg:find(k) and table.pack(msg:gsub(k, ""))[2] == 2 then
            local p1, p2 = msg:find(k)
            msg = msg:cut(p1, p2, true)
            msg = msg:insert(p1, v)
            p1, p2 = msg:find(k)
            msg = msg:cut(p1, p2, true)
            msg = msg:insert(p1, code .. "r")
        end
    end
    chat.say(msg)
end
while true do
    if grab() == "terminated" then break end
end
os.pullEvent = pull