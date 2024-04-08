#	B10ggy: Create simple blogs on the net

<p align="center">
  <img src="https://u.cubeupload.com/batmangreen/Logo.png" alt="Blog gee low go"/>
</p>

##	Before you continue!

Made something awesome with Bloggy? Why not add our button! Just copy and paste the code onto your site.

`<a href="https://github.com/gamemake-eng/B10ggy"><img src="https://u.cubeupload.com/batmangreen/bloggyButton.png"/></a>`

[img](https://u.cubeupload.com/batmangreen/bloggyButton.png)

##	What is this?

Bloggy (stylized as B10ggy) is a lightweight SSG for the purpose of creating simple blogs to be shared on the internet with ANY static host ([Neocities](https://neocities.org/), [Nekoweb](https://nekoweb.org/), etc). All you need is 2 html files and a json file to get started. The exe is also only 19kb! Which is a whole lot more smaller than something like hugo (about 20MB!).

##	But why not hugo?

Because that might be a bit too much for certain people. Sometimes you just want somthing simple and easy to use. Some people might not want to deal with stuff like git submodules if you want to add some styling to your site. Bloggy is meant for beginner to intermediate developers who just want to write some html and create a simple website outside of the current megacorp internet bubble.

##	How do I install it?

There is only windows builds for now. All you have to do is unzip, drag the "Bloggy" folder into your desired location, and [add it to your path](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/).

##	This sucks and you're fat how do I compile this?

1.	Download lua (5.3 recomended) and a C compiler (the build file uses [tcc](https://bellard.org/tcc/) but you can change it to fit your needs).

2.	Download the lua C libary and includes (5.2 recomended. Windows dlls are labeled lua-5.2.4_Win32_dllw6_lib.zip) and extract the zip

3.	Move filed from the include directory into the include dir of your C compiler

4.	If using tcc, get the dll file (or the equivalent on your system) and run tcc -impdef lua52.dll (replace dll with the equivalent on your system) and place the generated .def file in the libs folder of your instalation

5.	If using tcc, you should be able to just run lua53 build.lua in the project directory. You might need to change this for your C compiler of choice.

##	Special Thanks!

Thanks RXI for the [json.lua](https://github.com/rxi/json.lua) libary! It's the best pure lua json parser I found!

Thanks Eric R. Schulz for your [luastatic](https://github.com/ers35/luastatic) tool! It was really simple to use!

Thanks Jeff Kenny for your charaters Greg Heffley and Manny Heffley that I used in my examples.

Thanks Steve Francia and Bjørn Erik for creating Hugo which inspried me to create Bloggy.

Thanks Roberto Ierusalimschy, Luiz Henrique de Figueiredo and Waldemar Celes for creating Lua.

Thanks Intel for creating the CPU for the computer I programmed this one.

Thanks Neocities for starting my web development journey

Allthough I am not too fond of you, thanks google for creating the browser I tested this on.

Thanks Paul Kulchenko for creating ZeroBrane Studio.

Thanks Linus Torvalds for creating Git.

There is a bunch more people I could thank but I will end at thanking Tim Berners-Lee for creating the first website.