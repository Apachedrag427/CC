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
local new = get("https://raw.githubusercontent.com/Apachedrag427/CC/main/say.lua")
local old = fs.open(shell.getRunningProgram(), "r").readAll()
if new ~= old then
	print("Update detected, press 'y' to update, press 'n' to refuse")
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
if returnWhenUpdated then return end
local modules = peripheral.find("manipulator")
if not modules then
    error("Please put a manipulator with a creative chat recorder around this computer.", 0)
end
if not modules.hasModule("plethora:chat_creative") then
    error("Please put a creative chat recorder around this computer.", 0)
end
local chat = modules
local code = string.char(167)
local prefix
if not fs.exists(".prefix") then
    local file = fs.open(".prefix", "w")
    if file then
        file.write("[ChatBox] ")
        file.close()
    end
    error("Please go edit the .prefix file to customize your chatbox's prefix.  Use '&&' for the formatting character.", 0)
else
    local file = fs.open(".prefix", "r")
    if file then
        prefix = file.readLine()
        file.close()
        prefix = prefix:gsub("&&", code)
    end
end
return function(str)
    str = str:gsub("&&", code)
    chat.say(prefix .. str)
end
