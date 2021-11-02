package animate;

import flixel.math.FlxPoint;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxRect;
import haxe.Json;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import haxe.ds.IntMap;

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
		// FIX
		var ppp = '{"ATLAS": {"SPRITES":[ 
			{"SPRITE" : {"name": "0000","x":781,"y":478,"w":88,"h":116,"rotated": false}},
			{"SPRITE" : {"name": "0001","x":656,"y":478,"w":121,"h":131,"rotated": false}},
			{"SPRITE" : {"name": "0002","x":0,"y":0,"w":377,"h":426,"rotated": false}},
			{"SPRITE" : {"name": "0003","x":488,"y":478,"w":164,"h":163,"rotated": false}},
			{"SPRITE" : {"name": "0004","x":873,"y":478,"w":88,"h":116,"rotated": false}},
			{"SPRITE" : {"name": "0005","x":202,"y":430,"w":136,"h":200,"rotated": false}},
			{"SPRITE" : {"name": "0006","x":342,"y":478,"w":142,"h":190,"rotated": false}},
			{"SPRITE" : {"name": "0007","x":933,"y":348,"w":72,"h":43,"rotated": false}},
			{"SPRITE" : {"name": "0008","x":658,"y":239,"w":271,"h":235,"rotated": false}},
			{"SPRITE" : {"name": "0009","x":672,"y":0,"w":273,"h":235,"rotated": false}},
			{"SPRITE" : {"name": "0010","x":381,"y":0,"w":287,"h":235,"rotated": false}},
			{"SPRITE" : {"name": "0011","x":656,"y":613,"w":94,"h":42,"rotated": false}},
			{"SPRITE" : {"name": "0012","x":888,"y":598,"w":94,"h":44,"rotated": false}},
			{"SPRITE" : {"name": "0013","x":933,"y":298,"w":91,"h":46,"rotated": false}},
			{"SPRITE" : {"name": "0014","x":949,"y":0,"w":61,"h":54,"rotated": false}},
			{"SPRITE" : {"name": "0015","x":949,"y":106,"w":48,"h":46,"rotated": false}},
			{"SPRITE" : {"name": "0016","x":111,"y":634,"w":88,"h":42,"rotated": false}},
			{"SPRITE" : {"name": "0017","x":781,"y":598,"w":103,"h":42,"rotated": false}},
			{"SPRITE" : {"name": "0018","x":0,"y":637,"w":94,"h":32,"rotated": false}},
			{"SPRITE" : {"name": "0019","x":933,"y":239,"w":79,"h":55,"rotated": false}},
			{"SPRITE" : {"name": "0020","x":203,"y":634,"w":88,"h":40,"rotated": false}},
			{"SPRITE" : {"name": "0021","x":949,"y":58,"w":71,"h":44,"rotated": false}},
			{"SPRITE" : {"name": "0022","x":0,"y":579,"w":107,"h":54,"rotated": false}},
			{"SPRITE" : {"name": "0023","x":381,"y":239,"w":273,"h":235,"rotated": false}},
			{"SPRITE" : {"name": "0024","x":0,"y":430,"w":198,"h":145,"rotated": false}}
			]},
			"meta": {
			"app": "Adobe Animate",
			"version": "21.0.0.35450",
			"image": "spritemap1.png",
			"format": "RGBA8888",
			"size": {"w":1024,"h":676},
			"resolution": "1"
			}
			}
			';
		frames = fromAnimate(Paths.image('$anim/spritemap1'), ppp);
	}

	function fromAnimate(rawImg:String, rawJson:String):FlxAtlasFrames
	{
		var bitmapImg:FlxGraphic = FlxG.bitmap.add(rawImg);
		var bitmapResult:FlxAtlasFrames = FlxAtlasFrames.findFrame(bitmapImg);
		bitmapResult = new FlxAtlasFrames(bitmapImg);

		//trace(rawJson);
		var parsedJson:AnimateAtlas = Json.parse(rawJson);

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
