package animate;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import openfl.geom.Matrix;

class FlxSymbol extends FlxSprite
{
	public var coolParse:Parsed;
	public var oldMatrix:Array<Float> = [];

	// Loop types shit
	public static inline var LOOP:String = 'LP';
	public static inline var PLAY_ONCE:String = 'PO';
	public static inline var SINGLE_FRAME:String = 'SF';

	public var firstFrame:Int = 0;

	public var daLoopType:String = 'LP'; // LP by default, is set below!!!

	public function new(x:Float, y:Float, coolParsed:Parsed)
	{
		super(x, y);

		this.coolParse = coolParsed;

		var hasSymbolDictionary:Bool = Reflect.hasField(coolParse, "SD");

		if (hasSymbolDictionary)
			symbolAtlasShit = parseSymbolDictionary(coolParse);
	}

	var symbolAtlasShit:Map<String, String> = new Map();

	public var transformMatrix:Matrix = new Matrix();

	function renderFrame(TL:Timeline, coolParsed:Parsed, ?traceShit:Bool = false)
	{
		for (layer in TL.L)
		{
			if (FlxG.keys.justPressed.TWO)
				trace(layer.LN);

			var newFrameNum:Int = daFrame;

			switch (daLoopType)
			{
				case LOOP:
					//var tempFrame = layer.FR[newFrameNum + firstFrame % layer.FR];
					newFrameNum += 0;
				case PLAY_ONCE:
					newFrameNum += 0;
				case SINGLE_FRAME:
					newFrameNum = firstFrame;
			}

			var swagFrame:Frame = layer.FR[newFrameNum % layer.FR.length];

			for (element in swagFrame.E)
			{
				if (Reflect.hasField(element, 'ASI'))
				{
					var m3d = element.ASI.M3D;
					var dumbassMatrix:Matrix = new Matrix(m3d[0], m3d[1], m3d[4]);

					var spr:FlxSymbol = new FlxSymbol(0, 0, coolParsed);
					matrixExposed = true;
					spr.frames = frames;
					spr.frame = spr.frames.getByName(element.ASI.N);

					dumbassMatrix.concat(_matrix);
					spr.matrixExposed = true;
					spr.transformMatrix.concat(dumbassMatrix);

					spr.origin.set();

					spr.antialiasing = true;
					spr.draw();

					if (FlxG.keys.justPressed.ONE)
					{
						trace("ASI - " + layer.LN + ": " + element.ASI.N);
					}
				}
				else
				{
					var nestedSymbol = symbolMap.get(element.SI.SN);
					var nestedShit:FlxSymbol = new FlxSymbol(0, 0, coolParse);
					nestedShit.frames = frames;

					var swagMatrix:FlxMatrix = new FlxMatrix(element.SI.M3D[0], element.SI.M3D[13]);

					swagMatrix.concat(_matrix);

					nestedShit._matrix.concat(swagMatrix);
					nestedShit.origin.set(element.SI.TRP.x, element.SI.TRP.y);

					if (FlxG.keys.justPressed.ONE)
					{
						trace("SI - " + layer.LN + ": " + element.SI.SN + " - LO");
					}

					nestedShit.firstFrame = element.SI.FFP;

					nestedShit.daLoopType = element.SI.LP;
					nestedShit.daFrame = daFrame;
					nestedShit.scrollFactor.set(1, 1);
					nestedShit.renderFrame(nestedSymbol.TL, coolParsed);
				}
			}
		}
	}

	var symbolMap:Map<String, Animation> = new Map();

	function parseSymbolDictionary(coolParsed:Parsed):Map<String, String>
	{
		var awesomeMap:Map<String, String> = new Map();

		for (symbol in coolParsed.SD.S)
		{
			symbolMap.set(symbol.SN, symbol);

			var symbolName = symbol.SN;

			// on time reverse?
			symbol.TL.L.reverse();

			for (layer in symbol.TL.L)
			{
				for (frame in layer.FR)
				{
					for (element in frame.E)
					{
						if (Reflect.hasField(element, 'ASI'))
						{
							awesomeMap.set(symbolName, element.ASI.N);
						}
					}
				}
			}
		}

		return awesomeMap;
	}

	public var daFrame:Int;
	public var matrixExposed:Bool;

	function changeFrame(frameChange:Int = 0):Void
	{
		daFrame += frameChange;
	}

	override function drawFrame(Force:Bool = false):Void
	{
		super.drawFrame(Force);
	}
}

typedef Parsed =
{
	var AN:Animation;
	var SD:SymbolDictionary;
}

typedef Animation =
{
	var SN:String;
	var TL:Timeline;
	var STI:Dynamic;
}

typedef SymbolDictionary =
{
	var S:Array<Animation>;
}

typedef Timeline =
{
	var L:Array<Layer>;
}

typedef Layer =
{
	var LN:String;
	var FR:Array<Frame>;
}

typedef Frame =
{
	var I:Int;
	var DU:Int;
	var E:Array<Element>;
}

typedef Element =
{
	var SI:SymbolInstance;
	var ASI:AtlasSymbolInstance;
}

typedef SymbolInstance =
{
	var SN:String;
	var ST:String;

	var FFP:Int;
    var LP:String;

	var TRP:TransformationPoint;
	var M3D:Array<Float>;
}

typedef AtlasSymbolInstance =
{
	var N:String;
	var M3D:Array<Float>;
}

typedef TransformationPoint =
{
	var x:Float;
	var y:Float;
}
