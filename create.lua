function create(name, isdir)
	if isdir(name) then
		print("there is already a folder named "..name)
	else
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
end

return create