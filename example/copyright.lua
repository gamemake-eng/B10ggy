m = {}

function m:run(k,v)
	local fs = v
	fs = fs:gsub("@year", os.date("%Y",os.time()))
	fs = fs:gsub("@symbolC", "©")
	return fs
end

return m