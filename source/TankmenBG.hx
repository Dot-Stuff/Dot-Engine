package;

import flixel.FlxSprite;

class TankmenBG extends FlxSprite
{
    public static var animationNotes:Array<Dynamic> = [];

	var tankSpeed:Float = 0.7;
	var goingRight:Bool = false;
	public var strumTime:Int = 0;

	public function new(x:Int, y:Int)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('tankmanKilled1');
		antialiasing = true;

		animation.addByPrefix('run', 'tankman running', 24, true);
		animation.addByPrefix('shot', 'John Shot ${FlxG.random.int(1, 2)}', 24, false);
		animation.play('run');

		animation.curAnim.curFrame = FlxG.random.int(0, animation.curAnim.frames.length - 1);

		updateHitbox();
		setGraphicSize(Std.int(width * 0.8));
		updateHitbox();
	}

	var endingOffset:Float;

	public function resetShit(x:Int, y:Int, goingRight:Bool)
	{
		setPosition(x, y);

		this.goingRight = goingRight;
		endingOffset = FlxG.random.float(50, 200);
		tankSpeed = FlxG.random.float(0.6, 1);

		flipX = goingRight;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		x >= 1.2 * FlxG.width || x <= -0.5 * FlxG.width ? visible = false : visible = true;

		if (animation.curAnim.name == 'run')
		{
			var joe = 0.74 * FlxG.width + endingOffset;

			if (goingRight)
			{
				joe = 0.02 * FlxG.width - endingOffset;
                x = joe + (Conductor.songPosition - strumTime) * tankSpeed;
			}
            else
                x = joe - (Conductor.songPosition - strumTime) * tankSpeed;

            if (strumTime < Conductor.songPosition)
            {
                animation.play('shot');

                if (goingRight)
                    offset.set(300, 200);
            }
		}

        if (animation.curAnim.name == 'shot' && animation.curAnim.frames.length - 1 <= animation.curAnim.curFrame)
            kill();
	}
}
