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
