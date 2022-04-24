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

local function getMsg()
    while true do
        local _, plr, msg = os.pullEvent("chat_message")
        term.clearLine()
        print("\n<" .. plr .. "> ", msg)
        term.write("<You> ")
    end
end
local chat = peripheral.wrap("left")
local function joinMsg(str)
    chat.say(string.char(167) .. "e" .. str)
end
local sendMsgOnStart = false

local pull = os.pullEvent
os.pullEvent = function(Filter)
    local stuff = table.pack(os.pullEventRaw(Filter))
    if stuff[1] == "terminate" then
        if sendMsgOnStart then
            joinMsg("Apache has left the chat")
        else
            term.setTextColor(colors.yellow)
            print("Apache has left the chat")
            term.setTextColor(colors.white)
        end
        error("", 0)
    else
        return table.unpack(stuff)
    end
end
local written = false
if sendMsgOnStart then
    joinMsg("Apache has joined the chat")
else
    term.setTextColor(colors.yellow)
    print("Apache has joined the chat")
    term.setTextColor(colors.white)
end
local function sendStuff()
    term.write("<You> ")
    while true do
        if not written then written = true else term.write("      ") end
        local input = read()
        shell.run("say " .. input)
    end
end

parallel.waitForAll(getMsg, sendStuff)
print("Exited")
os.pullEvent = pull