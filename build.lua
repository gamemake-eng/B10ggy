local luapath = "C:/Program Files/zerobrain/bin/lua53.exe"

os.execute('"'..luapath..'" luastatic.lua main.lua json.lua createcmd.lua buildcmd.lua')
os.execute("tcc main.luastatic.c -llua52 -o build/bloggy.exe")
os.execute('"'..luapath..'" main.lua build example/settings.json')
os.execute('"'..luapath..'" main.lua build docs/settings.json')
os.execute("move docs/out build/docs")