m = {}
m.is_widget = true
function m:run(k,v)
	local fs = "Copyright"..v.author.." @year @symbolC"
	fs = fs:gsub("@year", os.date("%Y",os.time()))
	fs = fs:gsub("@symbolC", "©")
	return fs
end

return m