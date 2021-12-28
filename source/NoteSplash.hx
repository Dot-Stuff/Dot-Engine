package;

import shadersLmfao.ColorSwap;
import flixel.FlxSprite;

using StringTools;

class NoteSplash extends FlxSprite
{
	private var colorSwap:ColorSwap;

	public function new(x:Float, y:Float, noteData:Int = 0)
	{
		super(x, y);

		if (PlayState.curStage.startsWith('school'))
			frames = Paths.getSparrowAtlas('pixelUI/noteSplashes-pixels'); // TODO: Remake
		else
			frames = Paths.getSparrowAtlas('noteSplashes');

		animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
		animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

		animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		animation.addByPrefix("note3-1", "note impact 2 red", 24, false);

		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		updateColors(noteData);

		setupNoteSplash(x, y, noteData);
	}

	public function setupNoteSplash(noteX:Float, noteY:Float, noteData:Int = 0)
	{
		setPosition(noteX, noteY);

		alpha = 0.6;

		animation.play('note$noteData-${FlxG.random.int(0, 1)}', true);
		updateColors(noteData);

		var curAnim = animation.curAnim;

		curAnim.frameRate = curAnim.frameRate + FlxG.random.int(-2, 2);

		updateHitbox();
		offset.set(width * 0.3, height * 0.3);
	}

	function updateColors(noteData:Int)
	{
		colorSwap.update(Note.arrowColors[noteData]);
	}

	public override function update(elapsed:Float)
	{
		if (animation.curAnim.finished)
			kill();

		super.update(elapsed);
	}
}
