package;

import netTest.Net;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;
import flixel.util.FlxTimer;

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

	private var coolColors:Array<FlxColor> = [0x9271FD, 0x9271FD, 0x223344, 0x941653, 0xFC96D7, 0xA0D1FF, 0xFF78BF, 0xF6B604];

	override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		#if debug
		addSong('Test');
		#end

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (name in initSonglist)
		{
			addSong(name);
		}

		#if NO_PRELOAD_ALL
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		#end

		bg = new FlxSprite().loadGraphic(Paths.loadImage('menuDesat'));
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

			var icon:HealthIcon = new HealthIcon(songs[i].song.player2);
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

	public function addSong(songName:String)
	{
		var splitWords = songName.split(" ");
		var song = Song.loadFromJson(splitWords[0]);
		var shit = splitWords[1] == null ? 0 : Std.parseInt(splitWords[1]);

		songs.push({name: splitWords[0], week: shit, song: song});
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

		#if !mobile
		if (FlxG.mouse.wheel != 0)
		{
			// TODO: Fix this shit it's fps based >:(

			var whelSpop;

			#if !desktop
			whelSpop = -Math.round(FlxG.mouse.wheel / 4);
			#else
			whelSpop = -Math.round(FlxG.mouse.wheel);
			#end
			trace('wheel Spop: ' + whelSpop);
			changeSelection(whelSpop);
		}
		#else
		for (swipe in FlxG.swipes)
		{
			var degrees = swipe.angle; 
			degrees = (degrees % 360 + 360) % 360; 

			if (degrees != 0)
			{
				if (degrees <= 45)
					changeSelection(-1)
				else if (degrees >= 45)
					changeSelection(1);
				else if (degrees <= 180)
					changeDiff(-1);
				else if (degrees >= 180)
					changeDiff(1);
			}
			else
				accept();
		}
		#end

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
			accept();
	}

	function accept()
	{
		Net.send('switchSong', {
			name: songs[curSelected].name.toLowerCase(),
			storyMode: false,
			difficulty: curDifficulty,
			week: songs[curSelected].week
		});
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
	var song:Song.SwagSong;
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
