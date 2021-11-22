package;

import openfl.Assets;
import haxe.Json;
import haxe.ds.IntMap;
import animate.FlxSymbol;

class CutsceneCharacter extends FlxSymbol
{
    var nestedShit:IntMap<FlxSymbol> = new IntMap<FlxSymbol>();

	var frameTickTypeShit:Float;
    var playingAnim:Bool = false;

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

        if (FlxG.keys.justPressed.E)
        {
            if (nestedShit.keys().hasNext())
            {
                var nextShit = nestedShit.keys().next();
                nestedShit.get(nextShit).draw();
            }
            nestedShit.clear();
        }
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE)
			playingAnim = !playingAnim;

        if (playingAnim)
        {
            frameTickTypeShit += elapsed;

            if (frameTickTypeShit >= 0.041666666666666664)
            {
                changeFrame(1);
                frameTickTypeShit = 0;
            }
        }

        if (FlxG.keys.justPressed.RIGHT)
			changeFrame(1);
		if (FlxG.keys.justPressed.LEFT)
			changeFrame(-1);
    }
}
