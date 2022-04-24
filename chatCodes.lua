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
local new = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/chatCodes.lua")
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
local chat = peripheral.wrap("left")
chat.capture("")
local pull = os.pullEvent
os.pullEvent = os.pullEventRaw
local function grab()
	local event, msg, _, plr, uuid = os.pullEvent()
	if event == "terminate" then return "terminated" elseif event ~= "chat_capture" then return end
	msg = msg:gsub("&&", code)
	chat.say(msg)
end
while true do
	if grab() == "terminated" then break end
end
os.pullEvent = pull
chat.clearCaptures()
