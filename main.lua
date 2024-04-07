package.cpath = package.cpath.."./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
package.path = "./?.lua;../?.lua"

local args = {...}
io.stdout:setvbuf('no')
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
for i,v in ipairs(args) do
	if (args[i] == "--s") or (args[i] == "-s") or (args[i] == "--settings") or (args[i] == "-settings") then
		settingsfilename = args[i+1]
		dirp = settingsfilename:match("(.*/)")
	end
end

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
		if s.home.item then
			it = "<a href='./"..v.title:gsub(" ","_")..".html'>"..s.home.item:gsub("@title",v.title).."</a>\n"
		else
			it = "<a href='"..v.title:gsub(" ","_")..".html'>".."<p>"..v.title.."</p></a>\n"
		end
		list=list..it
		for a,b in pairs(v) do
			--print(a)
			if a == "body" then
				local htmlfile = read_file(b)
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
	local isdirok, direrr = isdir(dirp.."out")
	if not isdirok then
		os.execute("mkdir ".. dirp.."out")
	end
	
	local hpf = io.open(dirp.."out/index.html", "wb")
	
	hpf:write(home_template)
	hpf:close()
	
	for k,v in ipairs(files) do
		local tpf = io.open(dirp.."out/"..v.name, "wb")
	
		tpf:write(v.body)
		tpf:close()
		
	end
	
else
	print("file not found")
end