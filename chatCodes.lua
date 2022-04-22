local handle = http.get("https://raw.githubusercontent.com/Apachedrag427/CC/main/chatCodes.lua")
if handle then
	local current = fs.open(shell.getRunningProgram(), "r")
	local contents = current.readAll()
	current.close()
	local updated = handle.readAll() ~= contents
	if updated then
		local f = fs.open(shell.getRunningProgram(), "w")
		f.write(handle.readAll())
	end
	handle.close()
end
local code = string.char(167)
local chat = peripheral.wrap("left")
chat.capture("")
pull = os.pullEvent
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
