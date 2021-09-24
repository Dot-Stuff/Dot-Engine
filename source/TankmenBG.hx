package;

import flixel.FlxSprite;

class TankmenBG extends FlxSprite
{
    public static var animationNotes:Array<Dynamic> = [];

	var goingRight:Bool;
	var endingOffset:Float;
	var tankSpeed:Float;
	public var strumTime:Int;

	public function new(x:Int, y:Int)
	{
		super(x, y);

		tankSpeed = 0.7;
		goingRight = false;
		strumTime = 0;

		frames = Paths.getSparrowAtlas('tankmanKilled1');
		antialiasing = true;
		animation.addByPrefix("run", "tankman running", 24, true);
		animation.addByPrefix("shot", "John Shot " + FlxG.random.int(1, 2), 24, false);
		animation.play("run");
		animation.curAnim.curFrame = FlxG.random.int(0, animation.curAnim.frames.length - 1);

		updateHitbox();
		setGraphicSize(Std.int(0.8 * width));
		updateHitbox();
	}

	public function resetShit(x:Int, y:Int, goingRight:Bool)
	{
		setPosition(x, y);

		this.goingRight = goingRight;
		endingOffset = FlxG.random.float(50, 200);
		tankSpeed = FlxG.random.float(.6, 1);

		if (goingRight)
			flipX = true;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		x >= 1.2 * FlxG.width || x <= -0.5 * FlxG.width ? visible = false : visible = true;

		if (animation.curAnim.name == "run")
		{
			elapsed = 0.74 * FlxG.width + endingOffset;

			if (goingRight)
			{
				elapsed = 0.02 * FlxG.width - endingOffset;
                x = elapsed + (Conductor.songPosition - strumTime) * tankSpeed;
			}
            else
                x = elapsed - (Conductor.songPosition - strumTime) * tankSpeed;

            if (strumTime < Conductor.songPosition)
            {
                animation.play("shot");

                if (goingRight)
                    offset.set(300, 200);
            }
		}

        if (animation.curAnim.name == "shot" && animation.curAnim.frames.length - 1 <= animation.curAnim.curFrame)
            kill();
	}
}
