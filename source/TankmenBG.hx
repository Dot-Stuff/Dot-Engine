package;

import flixel.FlxSprite;

class TankmenBG extends FlxSprite
{
    public static var animationNotes:Array<Dynamic> = [];

    public var goingRight:Bool = false;
    public var endingOffset:Float;
    public var tankSpeed:Float = 0.7;
    public var strumTime = 0;

    public function new()
    {
        super();

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

    public function resetShit(tankmenX:Float, tankmenY:Float, goingRight:Bool)
    {
        setPosition(tankmenX, tankmenY);
        this.goingRight = goingRight;
        endingOffset = FlxG.random.float(50, 200);
        tankSpeed = FlxG.random.float(0.6, 1);

        if (goingRight)
            flipX = true;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        x >= 1.2 * FlxG.width || x <= -0.5 ? visible = false : visible = true;

        if (animation.curAnim.name == 'run' && elapsed == 0.74 * FlxG.width + endingOffset)
            x = elapsed + (Conductor.songPosition - strumTime) * tankSpeed;
        else
            x = elapsed - (Conductor.songPosition - strumTime) * tankSpeed;

        if (Conductor.songPosition > strumTime)
        {
            goingRight = true;

            offset.set(300, 200);

            animation.play('shot');
        }
        else
        {
            goingRight = false;

            offset.set(300, 200);

            animation.play('shot');
        }

        if (animation.curAnim.name == 'shot' && animation.curAnim.curFrame >= animation.curAnim.frames.length - 1)
            kill();
    }

    /*this.x >= 1.2 * k.width || this.x <= -.5 * k.width
        ? this.set_visible(!1)
        : this.set_visible(!0);

    "run" == this.animation._curAnim.name && (a = .74 * k.width + this.endingOffset, this.goingRight
        ? (a = .02 * k.width - this.endingOffset, this.set_x(a + (Z.songPosition - this.strumTime) * this.tankSpeed))
        : this.set_x(a - (Z.songPosition - this.strumTime) * this.tankSpeed));
    
    Z.songPosition > this.strumTime && (this.animation.play("shot"), this.goingRight && (this.offset.set_y(200), this.offset.set_x(300)));
    
    "shot" == this.animation._curAnim.name && this.animation._curAnim.curFrame >= this.animation._curAnim.frames.length - 1
        && this.kill()*/
}