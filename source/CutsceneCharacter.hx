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
        super.update(elapsed);

        /*if (anim != null && startSyncAudio != null && anim.curFrame >= startSyncFrame && !startedPlayingSound)
        {
            startedPlayingSound = true;
            startSyncAudio.play();
        }*/
    }
}
