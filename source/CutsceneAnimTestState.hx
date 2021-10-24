package;

import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import animate.FlxAnimate;
import flixel.FlxState;

class CutsceneAnimTestState extends FlxState
{
    var curSelected:Int;

    var debugTxt:FlxText;
    var char:FlxAnimate;

    public function new()
    {
        super();

        var bg = FlxGridOverlay.create(10, 10);
        bg.scrollFactor.set(0.5, 0.5);
        add(bg);

        debugTxt = new FlxText(900, 20, 0, '', 20);
        debugTxt.color = -16776961;
        add(debugTxt);

        char = new FlxAnimate(600, 200);
        add(char);
    }
}
