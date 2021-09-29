package;

import flixel.system.FlxSound;
import flixel.FlxSprite;

using StringTools;

class CutsceneCharacter
{
	public var onFinish:Void->Void;

	function parseOffsets()
	{
		for (var a = CoolUtil.coolTextFile(Paths.file('images/cutsceneStuff/${imageShit}CutsceneOffsets.txt', TEXT))
		{
			b = 0;
			b < a.length;
		}
	)
		{
			var c = a[b];
			++b;
			var d = X._pool.get().set(0, 0);
			d._inPool = !1;
			var e = L.trim(c.split("---")[1]).split(" ");
			trace("cool split: " + c.split("---")[1]);
			trace(e);
			d.set(parseFloat(e[0]), parseFloat(e[1]));
			e = this.animShit;
			var f = L.trim(c.split("---")[0]);
			e.h[f] = d;
			this.arrayLMFAOOOO.push(L.trim(c.split("---")[0]))
		}
		trace(animShit == null ? "null" : ba.stringify(this.animShit.h));
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
