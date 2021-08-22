package;

import ui.MenuState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MenuSubState
{
	private var menuItems:FlxTypedGroup<Alphabet>;

	var pauseMusic:FlxSound;

	var practiceText:FlxText;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 47, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueBalled:FlxText = new FlxText(20, 79, 0, "Blue Balled: " + PlayState.deathCounter, 32);
		blueBalled.scrollFactor.set();
		blueBalled.setFormat(Paths.font('vcr.ttf'), 32);
		blueBalled.updateHitbox();
		add(blueBalled);

		practiceText = new FlxText(20, 111, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.updateHitbox();
		practiceText.x -= FlxG.width + 20;
		practiceText.visible = false;
		add(practiceText);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		blueBalled.alpha = 0;
		practiceText.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueBalled.x = FlxG.width - (blueBalled.width + 20);
		practiceText.x = FlxG.width - (practiceText.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueBalled, {alpha: 1, y: blueBalled.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(practiceText, {alpha: 1, y: practiceText.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});

		menuItems = new FlxTypedGroup<Alphabet>();
		add(menuItems);

		pauseOG();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	public override function changeItem(direction:MenuDirections)
	{
		super.changeItem(direction);

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		var bullShit:Int = 0;

		for (item in menuItems.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	public override function acceptItem()
	{
		items[curSelected].onAccept();
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function difficultyChoices()
	{
		menuItems.clear();
		curSelected = 0;

		createItem('EASY', function()
		{
			PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase());
			PlayState.storyDifficulty = 0;
			FlxG.resetState();
		});

		createItem('NORMAL', function()
		{
			PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase());
			PlayState.storyDifficulty = 1;
			FlxG.resetState();
		});

		createItem('HARD', function()
		{
			PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase());
			PlayState.storyDifficulty = 2;
			FlxG.resetState();
		});

		createItem('BACK', function()
		{
			pauseOG();
		});

		for (i in 0...items.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, items[i].name, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			menuItems.add(songText);
		}

		changeItem(NONE);
	}

	function pauseOG()
	{
		menuItems.clear();
		curSelected = 0;

		createItem('Resume', function()
		{
			close();
		});

		createItem('Toggle Practice Mode', function()
		{
			PlayState.practiceMode = !PlayState.practiceMode;
			practiceText.visible = PlayState.practiceMode;
		});

		createItem('Change Difficulty', function()
		{
			difficultyChoices();
		});

		createItem('Restart Song', function()
		{
			FlxG.resetState();
		});

		createItem('Exit to menu', function()
		{
			PlayState.seenCutscene = false;
			PlayState.deathCounter = 0;
			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		});

		for (i in 0...items.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, items[i].name, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			menuItems.add(songText);
		}

		changeItem(NONE);
	}
}
