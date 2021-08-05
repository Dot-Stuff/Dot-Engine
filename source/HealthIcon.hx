package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		if (char != 'senpai' || char != 'spirit')
			antialiasing = true;
		
		var character:String;

		switch (char)
		{
			case 'gf-christmas' | 'gf-car' | 'gf-pixel':
				character = 'gf';
			case 'senpai-angry':
				character = 'senpai';
			case 'bf-christmas' | 'bf-car':
				character = 'bf';
			case 'mom-car':
				character = 'mom';
			case 'monster-christmas':
				character = 'monster';
			case 'parents-christmas':
				character = 'parents';
			default:
				character = char;
		}

		loadGraphic(Paths.image('icons/icon-${character}'), true, 150, 150);

		animation.add('default', [0, 1], 0, false, isPlayer);
		animation.play('default');

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
