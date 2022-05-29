local chat = peripheral.find("manipulator")
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
