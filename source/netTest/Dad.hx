package netTest;

import flixel.util.FlxTimer;
import flixel.FlxSprite;

class Dad extends FlxSprite
{
    public var curDirPressed:Array<Bool> = [false, false, false, false];

    public function new(x:Float, y:Float, needsSync:Bool)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');

        quickAnimAdd('idle', 'Dad Idle Dance');
        quickAnimAdd('singUP', 'Dad Sing Note UP');
        quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
        quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
        quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');

        animation.play('idle');

        drag.set(100, 100);

        if (needsSync)
        {
            new FlxTimer().start(1, function(tmr)
            {
                if (velocity.x == 0 && velocity.y == 0)
                    syncPos();
            }, 0);
        }
    }

    public var syncPos:Void->Void;

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        movementCode();
    }

    private function movementCode()
    {
        var left = curDirPressed[0];
        var right = curDirPressed[1];
        var up = curDirPressed[2];
        var down = curDirPressed[3];

        if (left && right)
            left = right = false;
        if (up && down)
            up = down = false;

        if (left || right || up || down)
        {
            if (left || right)
            {
                if (left)
                    velocity.x = -100;
                else
                    velocity.x = 100;
            }
            if (up || down)
            {
                if (up)
                    velocity.y = -100;
                else
                    velocity.y = 100;
            }
        }
    }

    public function quickAnimAdd(name:String, prefix:String)
    {
        animation.addByPrefix(name, prefix, 24, false);
    }
}