package;

import flixel.system.FlxSound;
import flixel.FlxSprite;
import lime.utils.Assets;

using StringTools;

class CutsceneCharacter
{
	public var onFinish:Void->Void;

	function parseOffsets()
	{
		for (i in CoolUtil.coolTextFile(Assets.getPath(Paths.image('${imageShit}CutsceneOffsets'))))
		{
			var e:String = ''.trim(''.split('---')[1]).split(" ");
		}
	}

	function createCutscene(a)
	{
		if (a == null)
			a = 0;

		var b = this;
		var character = new FlxSprite(coolPos.x + animShit.h[arrayLMFAOOOO[a]].x, coolPos.y + animShit.h[arrayLMFAOOOO[a]].y);
		var d = "cutsceneStuff/" + imageShit + "-" + a;
		character.frames = Paths.getSparrowAtlas(d);
		character.animation.addByPrefix("weed", arrayLMFAOOOO[a], 24, false);
		character.animation.play("weed");
		character.antialiasing = true;
		character.animation.finishCallback = function(d)
		{
			character.kill();
			character.destroy();
			a + 1 < b.arrayLMFAOOOO.length ? createCutscene(a + 1) : ended();
		};
		add(character);
	}

	function ended()
	{
		if (onFinish != null)
			onFinish();
	}
}
