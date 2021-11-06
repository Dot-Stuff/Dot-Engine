package;

import flixel.addons.display.FlxGridOverlay;
import flixel.FlxState;

class CutsceneAnimTestState extends FlxState
{
	var char:CutsceneCharacter;

	public function new()
	{
		super();

		var bg = FlxGridOverlay.create(10, 10);
		bg.scrollFactor.set(0.5, 0.5);
		add(bg);

		char = new CutsceneCharacter(600, 200, 'tightBars');
		add(char);
	}
}
