package ui;

import flixel.FlxState;
import ui.MenuState;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class OptionsState extends MusicBeatState
{
	public function new()
	{
		super();

		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('menuDesat'));
		bg.color = FlxColor.PURPLE;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);

        createItem('preferences', function()
        {
			FlxG.switchState(new PreferencesMenu());
        });
	}

	private function createItem(name:String, onAccept:Void->Void)
	{
		
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
	}
}

class Page extends FlxState
{
	
}
