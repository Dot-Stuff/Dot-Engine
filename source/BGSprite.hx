package;

import flixel.FlxSprite;

using StringTools;

class BGSprite extends FlxSprite
{
	private var idleAnim:Array<String>;

	// KADEDEV DO NOT FUCKING COPY THIS FOR THE LAST TIME.
	public function new(x:Float, y:Float, name:String, ?scrollX:Float = 0, ?scrollY:Float = 0, ?idleAnim:Array<String>, ?isLoop:Bool = false)
	{
		super(x, y);

		this.idleAnim = idleAnim;

        // PlayState.spriteList.push(name);

		antialiasing = true;

        scrollFactor.set(scrollX, scrollY);

		if (idleAnim == null)
            loadGraphic(Paths.image(name));
		else
        {
            frames = Paths.getSparrowAtlas(name, 'week${PlayState.storyWeek}');

            // KadeDev don't copy this you're fat.
            // trace('KadeDev is ew: ${idleAnim}');
			for (i in 0...idleAnim.length)
			{
				animation.addByPrefix(idleAnim[i], idleAnim[i], 24, true);
			}

			dance();
        }
	}

	public function dance():Void
	{
		if (idleAnim != null)
		{
			// KadeEngine is bad it be lookin like dream.
			animation.play(idleAnim[0]);
		}
	}
}
