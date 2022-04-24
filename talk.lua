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
    local file = fs.open(shell.getRunningProgram(), "w")
    if file then
        file.write(new)
        file.close()
        print("Updated")
        sleep(1)
        os.reboot()
    end
end
if not fs.exists("say.lua") then
    local stuff = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/say.lua")
    local file = fs.open("say.lua", "w")
    if file then
        file.write(stuff)
        file.close()
    end
end
if returnWhenUpdated then return end
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
        print("Join message sent.")
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
        joinMsg("Apache has left the chat")
        error("", 0)
    else
        return table.unpack(stuff)
    end
end
local written = false
joinMsg("Apache has joined the chat")
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