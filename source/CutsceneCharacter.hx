package;

import flixel.system.FlxSound;
import openfl.Assets;
import haxe.Json;
import haxe.ds.IntMap;
import animate.FlxSymbol;

class CutsceneCharacter extends FlxSymbol
{
    public var nestedShit:IntMap<FlxSymbol> = new IntMap<FlxSymbol>();

	var frameTickTypeShit:Float;
    public var playingAnim:Bool = false;

    public var startSyncAudio:FlxSound;
    var startedPlayingSound:Bool = false;

    public function new(x:Float, y:Float, anim:String)
    {
        coolParse = Json.parse(Assets.getText(Paths.file('images/$anim/Animation.json')));
		coolParse.AN.TL.L.reverse();

		super(x, y, coolParse);

        frames = Paths.getAnimateAtlas(anim);
    }

    public override function draw()
    {
        super.draw();

        renderFrame(coolParse.AN.TL, coolParse, true);
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (playingAnim)
        {
            frameTickTypeShit += elapsed;

            if (frameTickTypeShit >= 0.041666666666666664)
            {
                changeFrame(1);
                frameTickTypeShit = 0;
            }
        }

        if (daFrame >= 1 && !startedPlayingSound)
        {
            startSyncAudio.play();
            startedPlayingSound = true;
        }
    }
}
