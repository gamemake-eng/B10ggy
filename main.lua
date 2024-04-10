package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
package.cpath = package.cpath:gsub("\\","/")
package.path = "./?.lua;../?.lua"

--[[
Would you rather

Get to own Twitter but you have to become a neo-n***

Or

Have a gift card that can buy you anything in the world but everytime you use it you create one memory leak in some random code base
]]

--[[
    B10ggy: Make simples blogs for the net
    Copyright (C) 2024  michealtheratz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

]]

local args = {...}
io.stdout:setvbuf('no')
print([[
B10ggy  Copyright (C) 2024 Michealtheratz
This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE.txt.
This is free software, and you are welcome to redistribute it
under certain conditions; see LICENSE.txt for details.	
]])
print("Bloggy 0.0.1 'Yak'")
local json = require("json")
local create = require("createcmd")
local build = require("buildcmd")
function split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local function read_file(path)
	local f = io.open(path,"rb")
	if not f then return nil end
	local c = f:read("*a")
	
	f:close()
	return c
end
--- Check if a file or directory exists in this path
function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end
local function loadplugin(file)
	local f = assert(loadfile(file))
	return f()
end

local settingsfilename = "settings.json"
local dirp = ""
local mode = "idk"
local createpname = ""
for i,v in ipairs(args) do
	if args[i] == "build" then
		mode = "build"
		settingsfilename = args[i+1]
		dirp = settingsfilename:match("(.*/)")
	end
	
	if args[i] == "create" then
		mode = "create"
		createpname = args[i+1]
	end
	
	if args[i] == "help" then
		mode = "help"
	end
	
	
end

-- Help mode
if mode == "help" then
	print("create [project-name] - Creates a project")
	print("build path/to/settings.json - Builds a project")
elseif mode == "create" then
	local name = createpname
	create(name,isdir)
	
elseif mode == "build" then
	build(settingsfilename,dirp)
else
	print("Unknown. Type bloggy help for help")
end