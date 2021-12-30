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

	public override function draw()
	{
		super.draw();

		if (FlxG.keys.justPressed.E)
		{
			if (char.nestedShit.keys().hasNext())
			{
				var nextShit = char.nestedShit.keys().next();
				char.nestedShit.get(nextShit).draw();
			}
			char.nestedShit.clear();
		}
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
			char.playingAnim = !char.playingAnim;

		if (FlxG.keys.justPressed.RIGHT)
			char.changeFrame(1);
		if (FlxG.keys.justPressed.LEFT)
			char.changeFrame(-1);
	}
}
