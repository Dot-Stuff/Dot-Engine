![dot-engine-logo](art/preloaderArt.png)
[Join our Discord](https://www.discord.gg/u9B7qkkhtM)

This is the repository for Friday Night Funkin, a game originally made for Ludum Dare 47 "Stuck In a Loop".

[Play the Ludum Dare prototype](https://ninja-muffin24.itch.io/friday-night-funkin)

[Play on Newgrounds](https://www.newgrounds.com/portal/view/770371) or [Support the project](https://ninja-muffin24.itch.io/funkin)

## IF YOU MAKE A MOD AND DISTRIBUTE A MODIFIED / RECOMPILED VERSION, YOU MUST OPEN SOURCE YOUR MOD AS WELL

## Credits / shoutouts

- [ninjamuffin99 (me!)](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

This game was made with love to Newgrounds and it's community. Extra love to Tom Fulp.

## Build instructions

THESE INSTRUCTIONS ARE FOR COMPILING THE GAME'S SOURCE CODE!!!

IF YOU WANT TO JUST DOWNLOAD AND INSTALL AND PLAY THE GAME NORMALLY, GO TO ITCH.IO TO DOWNLOAD THE GAME FOR PC, MAC, AND LINUX!!

https://ninja-muffin24.itch.io/funkin

IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!!

### Installing the Required Programs

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe](https://haxe.org/download/)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Just copy and paste this into your terminal to install them:
```
haxelib install hscript
haxelib install newgrounds
haxelib install colyseus
haxelib install colyseus-websocket
haxelib install hxcs
haxelib install polymod
```

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You should have everything ready for compiling the game! Follow the guide below to continue!

### Ignored files

I gitignore the API keys for the game, so that no one can nab them and post fake high scores on the leaderboards. But because of that the game
doesn't compile without it.

Just make a file in `/source` and call it `APIStuff.hx`, and copy & paste this into it

```haxe
package;

class APIStuff
{
	public static inline var API:String = "";
	public static inline var EncKey:String = "";
}
```

and you should be good to go there.

### Compiling game

The -debug flag is completely optional.

Once you have all those installed, it's pretty easy to compile the game. You just need to run `lime test html5 -debug` in the root of the project to build and run the HTML5 version ([command prompt navigation guide can be found here](https://ninjamuffin99.newgrounds.com/news/post/1090480)).
To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run `lime test linux -debug` and then run the executable file in export/release/linux/bin. For Windows, you need to install [Visual Studio Community 2022](https://visualstudio.microsoft.com/downloads/). While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v143 - VS 2022 C++ x64/x86 build tools
* Windows 10 SDK (10.20348.0)

If on windows 11 install
* Windows 11 SDK (10.0.22000.0)

Once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
As for Mac, `lime test mac -debug` should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac.

### Compiling Song Conveter
This method will become deperated soon!

First, Run build-SongConverter.bat in art folder. Then, Read the line that shows the exe directory. Next, put in your preload/data. Finally, Run the exe.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)
