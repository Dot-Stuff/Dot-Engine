package;

import flixel.FlxSprite;

using StringTools;

class BGSprite extends FlxSprite
{
	private var idleAnim:String;

	public function new(name:String, x:Float, y:Float, scrollX:Float = 1, scrollY:Float = 1, ?anims:Array<String>, looped:Bool = false)
	{
		super(x, y);

		if (anims != null)
		{
			frames = Paths.getSparrowAtlas(name);

			for (i in anims)
			{
				animation.addByPrefix(i, i, 24, looped);
				animation.play(i);

				if (idleAnim == null)
					idleAnim = i;
			}
		}
		else
		{
			loadGraphic(Paths.loadImage(name));
			active = false;
		}

        scrollFactor.set(scrollX, scrollY);
		antialiasing = true;
	}

	public function dance():Void
	{
		if (idleAnim != null)
			animation.play(idleAnim);
	}
}
