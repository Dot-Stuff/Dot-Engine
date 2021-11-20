package;

import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import ui.PreferencesMenu;

using StringTools;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = ""; // Maybe add a thing for overriding

	private var randomGameover:Int = 1;

	public function new(x:Float, y:Float)
	{
		super();

		var daBf:String = PlayState.SONG.player1;
		stageSuffix = daBf.contains('pixel') ? '-pixel' : '';
		daBf.startsWith('pixel') ? daBf += '-dead' : daBf = 'bf';

		FlxG.sound.cache(Paths.music('gameOver$stageSuffix'));
		FlxG.sound.cache(Paths.music('gameOverEnd$stageSuffix'));

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx$stageSuffix'));
		Conductor.changeBPM(100);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		var naughtyList:Array<Int> = [];

		if (PreferencesMenu.getPref("censor-naughty"))
			naughtyList = [1, 3, 8, 13, 17, 21];

		randomGameover = FlxG.random.int(1, 24, naughtyList);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && !isEnding)
			endBullshit();

		if (controls.BACK)
		{
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			
			FlxG.sound.music.stop();

			FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (PlayState.storyWeek == 7)
		{
			if (bf.animation.curAnim.finished && !playingDeathSound)
			{
				playingDeathSound = true;

				bf.startedDeath = true;
				coolStartDeath(0.2);

				FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + randomGameover));
				FlxG.sound.music.fadeIn(0.2, 1, 4);
			}
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			bf.startedDeath = true;
			coolStartDeath();
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	public function coolStartDeath(?volume:Float = 1)
	{
		FlxG.sound.playMusic(Paths.music('gameOver$stageSuffix'), volume);
	}

	var isEnding:Bool = false;
	var playingDeathSound:Bool = false;

	function endBullshit():Void
	{
		isEnding = true;
		bf.playAnim('deathConfirm', true);
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
		});
	}
}
