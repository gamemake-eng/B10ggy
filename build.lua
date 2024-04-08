local luapath = "C:/Program Files/zerobrain/bin/lua53.exe"

os.execute('"'..luapath..'" luastatic.lua main.lua json.lua createcmd.lua buildcmd.lua')
os.execute("tcc main.luastatic.c -llua52 -o build/bloggy.exe")
os.execute("build/bloggy.exe build example/settings.json")
