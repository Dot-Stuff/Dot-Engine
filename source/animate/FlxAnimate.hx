package animate;

import flixel.math.FlxPoint;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxRect;
import haxe.Json;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

using StringTools;

class FlxAnimate extends FlxSymbol
{
    var frameTickTypeShit:Float;
    var playingAnim:Bool;

    public function new(x:Float, y:Float)
    {
        coolParse = Json.parse(Assets.getText(Paths.file('images/tightBars/Animation.json', TEXT)));
        coolParse.AN.TL.L.reverse();

        super(x, y, coolParse);

        frames = fromAnimate(Paths.image('tightBars/spritemap1'), Paths.json('tightBars/spritemap1'));
    }

    function fromAnimate(rawImg:String, rawJson:String):FlxAtlasFrames
    {
        var bitmapImg:FlxGraphic = FlxG.bitmap.add(rawImg);
        var bitmapResult:FlxAtlasFrames = FlxAtlasFrames.findFrame(bitmapImg);
        bitmapResult = new FlxAtlasFrames(bitmapImg);
        trace(bitmapImg);

        if (Assets.exists(rawJson))
        {
            var hmm = Assets.getText(rawJson.toLowerCase()).trim();
            var ppMoreLikePoop:Dynamic = cast Json.parse(hmm);
            var fuck:Array<Dynamic> = ppMoreLikePoop.ATLAS.SPRITES;

            for (i in fuck)
            {
                var spriteFrame:FlxRect = new FlxRect(i.x, i.y, i.width, i.height);
                var spriteSize:FlxPoint = new FlxPoint(0, 0);

                bitmapResult.addAtlasFrame(spriteFrame, spriteSize, i.SPRITE.x, i.name);
            }
        }

        return bitmapResult;
    }

    public override function draw()
    {
        super.draw();

        renderFrame(coolParse.AN.TL, coolParse, true);

        if (FlxG.keys.justPressed.ENTER)
        {
        }
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.E)
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

        if (FlxG.keys.justPressed.A)
            changeFrame(1);
        else if (FlxG.keys.justPressed.D)
            changeFrame(-1);
    }
}
