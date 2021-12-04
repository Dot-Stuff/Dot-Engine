package;

import flixel.FlxSprite;

using StringTools;

class BGSprite extends FlxSprite
{
	private var idleAnim:String;

	public function new(name:String, x:Float, y:Float, scrollX:Float = 1, scrollY:Float = 1, ?idleAnim:Array<String>, looped:Bool = false)
	{
		super(x, y);

		if (idleAnim != null)
		{
			frames = Paths.getSparrowAtlas(name);

			for (i in idleAnim)
			{
				animation.addByPrefix(i, i, 24, looped);
				animation.play(i);

				if (idleAnim == null)
					this.idleAnim = i;
			}
		}
		else
		{
			loadGraphic(Paths.image(name));
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
