local luapath = "C:/Program Files/zerobrain/bin/lua52.exe"

os.execute('"'..luapath..'" main.lua build example/settings.json')
os.execute('"'..luapath..'" main.lua create testproject')
os.execute('"'..luapath..'" main.lua build testproject/settings.json')