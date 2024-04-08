package.cpath = package.cpath.."./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
package.path = "./?.lua;../?.lua"

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
local mode = "build"
local createpname = ""
for i,v in ipairs(args) do
	if args[i] == "build" then
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
end

-- Create mode
if mode == "create" then
	local name = createpname
	os.execute("mkdir "..name)
	local sfs = io.open(name.."/settings.json","wb")
	sfs:write([[{
		"posts":[
			{
			"body":"Welcome to your new B10ggy project! You can replace this text with a filename!",
			"title":"Hello World"
			}
		],
		"homepage_template":"home.html",
		"post_template":"post.html",
		"author":"You",
		"blog":"]]..name..[["
}]])
	sfs:close()
	
	local hfs = io.open(name.."/home.html","wb")
	hfs:write([[<!DOCTYPE html>
<html>
<head>
	<!--You can change anything you want!-->
	<!--
	List of valid homepage tags
	
	@blog - Name of blog (blog setting in settings.json)
	@author - Author of blog (author setting in settings.json)
	@list - Generated list of posts
	@date - Current date when built
	@time - Current time when built
	-->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>@blog</title>
	
</head>
<body>
	<h1>@blog by @author</h1>
	@list
	<span>Last Updated @date at @time</span>
	<p><a href="https://github.com/gamemake-eng/B10ggy"><img src="https://u.cubeupload.com/batmangreen/bloggyButton.png"/></a></p>
</body>
</html>]])
	hfs:close()
	
	local pfs = io.open(name.."/post.html","wb")
	pfs:write([[<!DOCTYPE html>
<html>
<head>
<!--
	List of valid post tags
	
	@title - Title of post (title setting)
	@body - Body of post (body setting)
	@... - Any other tags will be replaced by it's corsponding setting in the post
	-->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>@title</title>
	
</head>
<body>
	<h1>@title</h1>
	<p>@body</p>
</body>
</html>]])
pfs:close()
print("Project Created")
print("Now you can build it with bloggy build "..name.."/settings.json or just bloggy build if you go into the project directory")
end

-- Build Mode
if mode == "build" then
	local settings = read_file(settingsfilename)
	if settings then
		s = json.decode(settings)
	else
		s = nil
	end
	if s then
		if s["plugins"] then
			print("Loading plugins")
			for k,v in pairs(s.plugins) do
				s.plugins[k] = loadplugin(dirp..v)
				
			end
		end
		print("Reading "..s.blog)
		local template = read_file(dirp..s.post_template)
		local home_template = read_file(dirp..s.homepage_template)
		local list = ""
		local files = {}
		for k,v in ipairs(s.posts) do
			local ff = template
			print("Rendering '"..v.title.."'")
			local it = ""
			if s.home and s.home.item then
				it = "<a href='./"..v.title:gsub(" ","_")..".html'>"..s.home.item:gsub("@title",v.title).."</a>\n"
			else
				it = "<a href='"..v.title:gsub(" ","_")..".html'>".."<p>"..v.title.."</p></a>\n"
			end
			list=list..it
			for a,b in pairs(v) do
				--print(a)
				if a == "body" then
					local htmlfile = read_file(dirp..b)
					if htmlfile then
						ff = ff:gsub("@"..a,htmlfile)
					else
						ff = ff:gsub("@"..a,b)
					end
				elseif a == "author" then
					ff = ff:gsub("@author",s.author)
				else
					if s.plugins then
						if s.plugins[a] then
							local o = s.plugins[a]:run(a,b)
							ff = ff:gsub("@"..a,o)
						else
							ff = ff:gsub("@"..a,b)
						end
					else
						ff = ff:gsub("@"..a,b)
					end
				end
				
				
			end
			
			table.insert(files, {name=v.title:gsub(" ","_")..".html",body=ff})
			
			
		end

		print("Rendering home page")

		home_template = home_template:gsub("@blog",s.blog)

		home_template = home_template:gsub("@list",list)

		home_template = home_template:gsub("@author",s.author)
		
		home_template = home_template:gsub("@date",os.date("%B %d, %Y",os.time()))
		
		home_template = home_template:gsub("@time",os.date("%I:%M %p",os.time()))
		
		print("Saving")
		local foldername = "out"
		local filenameout = "index.html"
		if s.folder_name then
			foldername = s.folder_name
		end
		if s.home and s.home.file then
			filenameout = s.home.file
		end
		local isdirok, direrr = isdir(dirp..foldername)
		if not isdirok then
			os.execute("mkdir ".. dirp..foldername)
		end
		
		local hpf = io.open(dirp..foldername.."/"..filenameout, "wb")
		
		hpf:write(home_template)
		hpf:close()
		
		for k,v in ipairs(files) do
			local tpf = io.open(dirp..foldername.."/"..v.name, "wb")
			
			tpf:write(v.body)
			tpf:close()
			
		end
		if s.public_files then
			for k,v in pairs(s.public_files) do
				local tpf = io.open(dirp..foldername.."/"..v, "wb")
				if tpf == nil then
					os.execute("mkdir ".. dirp..foldername.."/"..v:match("(.*/)"))
					tpf = io.open(dirp..foldername.."/"..v, "wb")
				end
				tpf:write(read_file(dirp..v))
				tpf:close()
				
			end
		end
	else
		print("settings.json not found! If it's in a diffrent directory or has a diffrent name run bloggy build [file].json")
	end
end