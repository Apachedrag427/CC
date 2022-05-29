local args = {...}
local returnWhenUpdated = false
if args[1] == "update" then
    returnWhenUpdated = true
end
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
local new = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/talk.lua")
local old = fs.open(shell.getRunningProgram(), "r").readAll()
if new ~= old then
	print("Update detected in main program, press 'y' to update, press 'n' to refuse")
	local _, key = os.pullEvent("key")
	if key == keys.y then
		local file = fs.open(shell.getRunningProgram(), "w")
    	if file then
        	file.write(new)
        	file.close()
        	print("Updated")
        	sleep(1)
        	os.reboot()
    	end
	else
		print("Not updating")
	end
end
if not fs.exists("say.lua") then
    local stuff = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/say.lua")
    local file = fs.open("say.lua", "w")
    if file then
        file.write(stuff)
        file.close()
    end
else
	local new = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/say.lua")
	local old = fs.open("/say.lua", "r").readAll()
	if new ~= old then
		print("Update detected in api, press 'y' to update, press 'n' to refuse")
		local _, key = os.pullEvent("key")
		if key == keys.y then
			local file = fs.open("/say.lua", "w")
	    	if file then
	        	file.write(new)
	        	file.close()
	        	print("Updated")
	        	sleep(1)
	        	os.reboot()
	    	end
		else
			print("Not updating")
		end
	end
end
if returnWhenUpdated then return end
local nick
if not fs.exists(".nick") then
    local file = fs.open(".nick", "w")
    if file then
        file.write("ChatBox")
        file.close()
    end
    error("Please go edit the .nick file to customize your chatbox's nickname.  This is used in the chat join/leave msg", 0)
else
    local file = fs.open(".nick", "r")
    if file then
        nick = file.readLine()
        file.close()
    end
end
local say = require("say")
local modules = peripheral.find("manipulator")
if not modules then
    error("Please put a manipulator with a creative chat recorder around this computer.", 0)
end
if not modules.hasModule("plethora:chat_creative") then
    error("Please put a creative chat recorder around this computer.", 0)
end
local chat = modules
if not chat then error("Please put a creative chat recorder around this computer.", 0) end
local function getMsg()
    while true do
        local _, plr, msg = os.pullEvent("chat_message")
        term.clearLine()
        print("\n<" .. plr .. "> ", msg)
        term.write("<You> ")
    end
end
local publicJoinMsg = true
local function joinMsg(str)
    if publicJoinMsg then
        chat.say(string.char(167) .. "e" .. str)
    else
        term.setTextColor(colors.yellow)
        term.clearLine()
        print(str)
        term.setTextColor(colors.white)
    end
end

local pull = os.pullEvent
os.pullEvent = function(Filter)
    local stuff = table.pack(os.pullEventRaw(Filter))
    if stuff[1] == "terminate" then
        if not termed then
            termed = true
            joinMsg(nick .. " has left the chat")
			term.clear()
			term.setCursorPos(1,1)
            error("", 0)
        end
    else
        return table.unpack(stuff)
    end
end
local written = false
joinMsg(nick .. " has joined the chat")
local function sendStuff()
    term.write("<You> ")
    while true do
        if not written then written = true else term.write("      ") end
        local input = read()
        say(input)
    end
end

parallel.waitForAll(getMsg, sendStuff)
print("Exited")
os.pullEvent = pull
