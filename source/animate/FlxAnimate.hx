package animate;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.Json;
import haxe.ds.IntMap;
import lime.utils.Assets;
import openfl.geom.Rectangle;

using StringTools;

class FlxAnimate extends FlxSymbol
{
	var nestedShit:IntMap<FlxSymbol> = new IntMap<FlxSymbol>();

	var frameTickTypeShit:Float;
	var playingAnim:Bool;

	public function new(x:Float, y:Float, anim:String)
	{
		coolParse = Json.parse(Assets.getText(Paths.file('images/$anim/Animation.json')));
		coolParse.AN.TL.L.reverse();

		super(x, y, coolParse);

		// DOES NOT WORK WITH ROTATE EXPORT
		frames = fromAnimate(Paths.image('$anim/spritemap1'), Paths.file('images/$anim/spritemap1.json'));
	}

	function fromAnimate(rawImg:String, rawJson:String):FlxAtlasFrames
	{
		var bitmapImg:FlxGraphic = FlxG.bitmap.add(rawImg);
		var bitmapResult:FlxAtlasFrames = FlxAtlasFrames.findFrame(bitmapImg);
		bitmapResult = new FlxAtlasFrames(bitmapImg);

		trace(rawJson);
		var parsedJson:AnimateAtlas = cast Json.parse(Assets.getText(rawJson));

        for (i in parsedJson.ATLAS.SPRITES)
        {
            var data:AnimateSpriteData = i.SPRITE;

            var frame:FlxRect = FlxRect.get(data.x, data.y, data.w, data.h);
            var rectangleSize:Rectangle = new Rectangle(0, 0, frame.width, frame.height);

            var offset:FlxPoint = FlxPoint.get(-rectangleSize.left, -rectangleSize.top);
            var sourceSize:FlxPoint = FlxPoint.get(rectangleSize.width, rectangleSize.height);

            bitmapResult.addAtlasFrame(frame, sourceSize, offset, data.name);
        }

		return bitmapResult;
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

typedef AnimateAtlas = {
    var ATLAS:AnimateSprites;
};

typedef AnimateSprites = {
    var SPRITES:Array<AnimateSprite>;
};

typedef AnimateSprite = {
    var SPRITE:AnimateSpriteData;
};

typedef AnimateSpriteData = {
    var name:String;
    var x:Float;
    var y:Float;
    var w:Float;
    var h:Float;
};
