package;

import FreeplayState.MenuText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<MenuText>;

	var menuItems:Array<String> = [];
	var difficultyChoices:Array<String> = ["EASY", "NORMAL", "HARD", "BACK"];
	var pauseOG:Array<String> = [
		"Resume",
		"Restart Song",
		"Change Difficulty",
		"Toggle Practice Mode",
		"Exit to menu"
	];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var practiceText:FlxText;

	public function new()
	{
		super();

		menuItems = pauseOG;

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
		practiceText.visible = PlayState.practiceMode;
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

		grpMenuShit = new FlxTypedGroup<MenuText>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:MenuText = new MenuText(0, (70 * i) + 30, menuItems[i], Bold);
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	function regenMenu()
	{
		while (grpMenuShit.members.length > 0)
			grpMenuShit.remove(grpMenuShit.members[0], true);

		for (i in 0...menuItems.length)
		{
			var songText:MenuText = new MenuText(0, (70 * i) + 30, menuItems[i], Bold);
			grpMenuShit.add(songText);
		}

		curSelected = 0;
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if (controls.UI_UP_P)
			changeSelection(-1);
		else if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Toggle Practice Mode":
					PlayState.practiceMode = !PlayState.practiceMode;
					practiceText.visible = PlayState.practiceMode;
				case 'EASY' | 'MEDIUM' | 'HARD':
					PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();
				case "Restart Song":
					FlxG.resetState();
				case "BACK":
					menuItems = pauseOG;
					regenMenu();
				case "Change Difficulty":
					menuItems = difficultyChoices;
					regenMenu();
				case "Exit to menu":
					PlayState.seenCutscene = false;
					PlayState.deathCounter = 0;
					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		for (i in 0...grpMenuShit.members.length)
		{
			var item = grpMenuShit.members[i];

			item.targetY = i - curSelected;

			item.alpha = item.targetY == 0 ? 1 : 0.6;
		}
	}
}
