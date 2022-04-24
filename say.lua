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
local modules = peripheral.find("manipulator")
if not modules then
    error("Please put a manipulator with a creative chat recorder around this computer.", 0)
end
if not modules.hasModule("plethora:chat_creative") then
    error("Please put a creative chat recorder around this computer.", 0)
end
local chat = modules
local code = string.char(167)
local prefix = code .. "a" .. code .. "o[Apache] " .. code .. "r"
return function(str)
    str = str:gsub("&&", code)
    chat.say(prefix .. str)
end