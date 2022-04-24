if not http then
	error("Please enable http in config.", 0)
end
local function get(url)
	local response = http.get(url)
	if not response then
		error("Could not get " .. url, 0)
	end
	local data = response.readAll()
	response.close()
	return data
end
local new = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/mdTest.lua")
local old = fs.open(shell.getRunningProgram(), "r").readAll()
if new ~= old then
    local file = fs.open(shell.getRunningProgram(), "w")
    if file then
        file.write(new)
        file.close()
    end
    print("Updated")
end
local code = string.char(167)
local codes = {
    {
        ["***"] = code .. "o" .. code .. "l",
    },
    {
        ["**"] = code .. "l",
    },
    {
        ["*"] = code .. "o",
    },
    {
        ["_"] = code .. "n",
    },
    {
        ["~~"] = code .. "m",
    },
}
local reset = code .. "r"
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
    for k, v in ipairs(codes) do
        for i, val in pairs(v) do
            if msg:find(i) and table.pack(msg:gsub(i, ""))[2] == 2 then
                local p1, p2 = msg:find(i)
                msg = msg:cut(p1, p2, true)
                msg = msg:insert(p1 - 1, val)
                p1, p2 = msg:find(i)
                msg = msg:cut(p1, p2, true)
                msg = msg:insert(p1, reset)
            end
        end
    end
    chat.say(msg)
end
while true do
    if grab() == "terminated" then break end
end
os.pullEvent = pull
chat.clearCaptures()
