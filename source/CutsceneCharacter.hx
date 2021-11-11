package;

import openfl.Assets;
import haxe.Json;
import haxe.ds.IntMap;
import animate.FlxSymbol;

class CutsceneCharacter extends FlxSymbol
{
    var nestedShit:IntMap<FlxSymbol> = new IntMap<FlxSymbol>();

	var frameTickTypeShit:Float;
    var playAnim:Bool = true;

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

        if (playAnim)
        {
            playAnim = false;

            frameTickTypeShit += elapsed;

            if (frameTickTypeShit >= 0.041666666666666664)
            {
                changeFrame(1);
                frameTickTypeShit = 0;
            }
        }
    }
}
