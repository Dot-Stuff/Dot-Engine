package;

import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];

		var swagArray:Array<String> = Assets.getText(path).trim().split('\n');

		for (item in swagArray)
		{
			// Comment support in the quick lil text formats??? using //
			if (!item.trim().startsWith('//'))
				daList.push(item);
		}

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static inline function numberArray(max:Int, ?min = 0):Array<Int>
	{
		return [for(i in min...max) i];
	}

	public static function camLerpShit(ratio:Float):Float
	{
		return FlxG.elapsed / 0.016666666666666666 * ratio;
	}

	public static function coolLerp(a:Float, b:Int, ratio:Float):Float
	{
		return a + camLerpShit(ratio) * (b - a);
	}
}
