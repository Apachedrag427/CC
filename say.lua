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
local chat = peripheral.find("plethora:chat_creative")
if not chat then error("Please put a creative chat recorder around this computer.", 0) end
local code = string.char(167)
local prefix = code .. "a" .. code .. "o[Apache] " .. code .. "r"
if {...} then
    local args = {...}
    local result = ""
    if #args > 1 then
        for i,v in ipairs(args) do
            result = result .. v .. (i < #args and " " or "")
        end
    elseif #args == 1 then
        result = args[1]
    else
        error("Please provide something to say", 0)
    end
    result = result:gsub("&&", code)
    chat.say(prefix .. result)
else
    return function(str)
        str = str:gsub("&&", code)
        chat.say(prefix .. str)
    end
end