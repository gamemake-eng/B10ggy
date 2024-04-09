local json = require("json")

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


function build(settingsfilename, dirp)
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
						local fhf = htmlfile--:gsub("%","%%")
						ff = ff:gsub("@"..a,fhf)
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
		
		if s.home and s.home.tags then
			for a,b in pairs(s.home.tags) do
				if s.plugins then
						if s.plugins[a] then
							local o = s.plugins[a]:run(a,b)
							home_template = home_template:gsub("@"..a,o)
						else
							home_template = home_template:gsub("@"..a,b)
						end
				else
					home_template = home_template:gsub("@"..a,b)
				end
			end
		end
		
		
		
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
					
					local dirs = split(v:match("(.*/)"), "/")
					for i,n in ipairs(dirs) do
						local rf = ""
						for d=1,i do
							rf = rf..dirs[d].."/"
						end
						
						os.execute("mkdir ".. dirp..foldername.."/"..rf)
						
					end
					--os.execute("mkdir ".. dirp..foldername.."/"..v:match("(.*/)"))
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

return build