package;

import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;
import flixel.util.FlxTimer;

using flixel.util.FlxColorTransformUtil;
using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	var songWait:FlxTimer = new FlxTimer();

	var bg:FlxSprite;
	var scoreBG:FlxSprite;

	private var grpSongs:FlxTypedGroup<MenuText>;
	private var curPlaying:Bool = false;

	private var grpsIcons:FlxTypedGroup<HealthIcon>;

	private var coolColors:Array<FlxColor> = [-7179779, -7179779, -14535868, -7072173, -223529, -6237697, -34625, -608764];

	override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		addSong('Test', 1, 'bf-pixel');
		#end

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			addSong(initSonglist[i], 1, 'gf');
		}

		#if NO_PRELOAD_ALL
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		#end

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);

		if (StoryMenuState.weekUnlocked[3] || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (StoryMenuState.weekUnlocked[4] || isDebug)
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		if (StoryMenuState.weekUnlocked[5] || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

		if (StoryMenuState.weekUnlocked[6] || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);

		if (StoryMenuState.weekUnlocked[7] || isDebug)
			addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman']);

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<MenuText>();
		add(grpSongs);

		grpsIcons = new FlxTypedGroup<HealthIcon>();
		add(grpsIcons);

		for (i in 0...songs.length)
		{
			var songText:MenuText = new MenuText(0, (70 * i) + 30, songs[i].name.replace('-', ' '), Bold);
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].character);
			icon.sprTracker = songText;
			grpsIcons.add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push({name: songName, week: weekNum, character: songCharacter});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.volume < 0.7)
				FlxG.sound.music.volume += 0.5 * elapsed;
		}

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);

		bg.color = FlxColor.interpolate(bg.color,
			coolColors[songs[curSelected].week % coolColors.length],
			CoolUtil.camLerpShit(0.045));

		scoreText.text = "PERSONAL BEST:" + Math.round(lerpScore);

		positionHighscore();

		if (FlxG.mouse.wheel != 0)
		{
			//Cleanup.
			// Due to edge or chrome not liking mouseWheel / 4 it goes to 0

			var whelSpop;

			#if !desktop
			whelSpop = -Math.round(FlxG.mouse.wheel / 4);
			#else
			whelSpop = -Math.round(FlxG.mouse.wheel);
			#end
			trace('wheel Spop: ' + whelSpop);
			changeSelection(whelSpop);
		}

		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));

			#if PRELOAD_ALL
			FlxG.sound.music.stop();
			#end

			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			PlayState.SONG = Song.loadFromJson(songs[curSelected].name.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	override function switchTo(nextState:FlxState):Bool
	{
		clearDaCache(songs[curSelected].name);
		return super.switchTo(nextState);
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		intendedScore = Highscore.getScore(songs[curSelected].name, curDifficulty);

		PlayState.storyDifficulty = curDifficulty;

		diffText.text = '< ${CoolUtil.difficultyString()} >';

		positionHighscore();
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;
		diffText.x = scoreBG.x + Std.int(scoreBG.width / 2);
		diffText.x -= diffText.width / 2;
	}

	function clearDaCache(currentSongName:String)
	{
		for (song in songs)
		{
			var songName = song.name;

			if (currentSongName != songName)
			{
				trace('trying to remove: $songName');

				Assets.cache.clear(Paths.inst(songName));
				Assets.cache.clear(Paths.voices(songName));
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		#if newgrounds
		intendedScore = Highscore.getScore(songs[curSelected].name, curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.music.stop();
		songWait.cancel();
		songWait.start(1, function(tmr:FlxTimer) {
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].name), 0);
		});
		#end

		for (i in 0...grpSongs.members.length)
		{
			var item = grpSongs.members[i];
			var icon = grpsIcons.members[i];

			item.targetY = i - curSelected;

			item.alpha = 0.6;
			icon.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
				icon.alpha = 1;
			}
		}
	}
}

typedef SongMetadata = {
	var name:String;
	var week:Int;
	var character:String;
}

class MenuText extends ui.AtlasText
{
	public var targetY:Float = 0;

	override function update(elapsed:Float)
	{
		var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

		y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
		x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16);

		super.update(elapsed);
	}
}
