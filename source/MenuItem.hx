package;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Int = 0;
	public var week:FlxSprite;
	public var flashingInt:Int = 0;

	public function new(x:Float, y:Float, weekNum:Int = 0)
	{
		super(x, y);

		week = new FlxSprite().loadGraphic(Paths.image('storymenu/week' + weekNum));
		week.antialiasing = true;
		add(week);
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	var fakeFramerate:Int;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		fakeFramerate = Math.round((1 / elapsed) / 10);

		y = CoolUtil.coolLerp(y, (targetY * 120) + 480, 0.17);

		if (isFlashing)
			flashingInt++;

		week.color = flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2) ? 0xFF33ffff : FlxColor.WHITE;
	}
}
