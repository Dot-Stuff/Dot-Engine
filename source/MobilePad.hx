package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxVirtualPad;

class MobilePad extends FlxVirtualPad
{
    public var dPadMode:FlxDPadMode;
    public var actionMode:FlxActionMode;

    public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode)
    {
        dPadMode = DPad;
        actionMode = Action;

        super(DPad, Action);
        alpha = 0.6;
    }

    public function tweenPad()
    {
        for (i in 0...dPad.members.length)
        {
            var btn = dPad.members[i];

            btn.y -= 10;
            btn.x -= 10;
            btn.alpha = 0;
            FlxTween.tween(btn, {x: btn.x + 10, y: btn.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
        }
    }
}
