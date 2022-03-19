package;

import flxanimate.FlxAnimate;
import flixel.system.FlxSound;

class CutsceneCharacter extends FlxAnimate
{
    public var startSyncAudio:FlxSound;
    public var startSyncFrame:Int = 1;

    var startedPlayingSound:Bool = false;

    public override function update(elapsed:Float)
    {
        /*var upP = FlxG.keys.pressed.W;
		var rightP = FlxG.keys.pressed.D;
		var downP = FlxG.keys.pressed.S;
		var leftP = FlxG.keys.pressed.A;

        var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

        if (upP || rightP || downP || leftP)
        {
            if (upP)
                y -= 0.1 * multiplier;
            if (downP)
                y += 0.1 * multiplier;
            if (leftP)
                x -= 0.1 * multiplier;
            if (rightP)
                x += 0.1 * multiplier;

            trace('cutsceneCharacter' + toString());
        }*/

        super.update(elapsed);

        if (anim != null && startSyncAudio != null && anim.curFrame >= startSyncFrame && !startedPlayingSound)
        {
            startedPlayingSound = true;
            startSyncAudio.play();
        }
    }
}
