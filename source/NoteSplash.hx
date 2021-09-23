package;

import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public function new(x:Float, y:Float, noteData:Int)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('noteSplashes');

		animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
		animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

		animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		animation.addByPrefix("note3-1", "note impact 2 red", 24, false);

		setupNoteSplash(x, y, noteData);
	}

	public function setupNoteSplash(noteX:Float, noteY:Float, noteData:Int)
	{
		#if web
		if (noteData == null)
			return;
		#end

		setPosition(noteX, noteY);

		alpha = 0.6;

		animation.play('note$noteData-${FlxG.random.int(0, 1)}', true);
		var curAnimation = animation.curAnim;

		if (curAnimation != null)
			curAnimation.frameRate = curAnimation.frameRate + FlxG.random.int(-2, 2);

		updateHitbox();
		offset.set(0.3 * width, 0.3 * height);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (animation.curAnim.finished)
			kill();
	}
}
