package ui;

import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.FlxSprite;
import haxe.ds.EnumValueMap;

using StringTools;

enum AtlasFont
{
	Default;
	Bold;
}

enum Case
{
	Both;
	Upper;
	Lower;
}

class AtlasText extends FlxSpriteGroup
{
	public var text:String = '';

	public var font:AtlasFontData;

	public var fonts:EnumValueMap<AtlasFont, AtlasFontData> = new EnumValueMap<AtlasFont, AtlasFontData>();

	public function new(x:Float, y:Float, name:String, atlasFont:AtlasFont = Default)
	{
		if (!fonts.exists(atlasFont))
			fonts.set(atlasFont, new AtlasFontData(atlasFont.getName()));

		super(x, y);

		text = name;
	}

	public function set_text(name:String)
	{
		var b = restrictCase(name);
		var c = restrictCase(text);

		text = name;

		if (b == c)
			return name;
		/*if (b.indexOf(c) == 0)
			return appendTextCased(b.substr(c.length)).text;
		name = b;
		group.kill();
		if (name == "")
			return text;

		appendTextCased(b);*/

		return text;
	}

	function restrictCase(textShit:String)
	{
		switch (font.caseAllowed)
		{
			case Both:
				return textShit;
			case Upper:
				return textShit.toUpperCase();
			case Lower:
				return textShit.toLowerCase();
		}
	}

	function appendTextCased(a:Array<String>)
	{
		var living = group.countLiving();
		var c:Float;
		var d:Float;
		/*if (living == -1)
				living = 0
			else if (living > 0)
				d = group.members[living - 1]; */
		/*c = d.x + d.width - x;
			d = d.y + d.height - font.maxHeight - y; */
		/*a = a.split("");

			for (i in 0...a.length)
			{
				switch (i)
				{
					case '\n':
						c = 0;
						d += font.maxHeight;
						break;
					case ' ':
						c += 40;
					default:
						var k:AtlasChar;

						if (living >= group.members.length)
							k = new AtlasChar(null, null, font.atlas, i);
						else
						{
							k = group.members[living];
							k.revive();
							k.char = i;
							k.alpha = 1;
						}

						k.x = c;
						k.y = d + font.maxHeight - k.height;
						add(k);
						c += k.width;
			}
		}*/
	}
}

class AtlasFontData
{
	public var caseAllowed:Case = Both;
	public var maxHeight:Float = 0;

	public var atlas:FlxFramesCollection;

	var upperChar:EReg = new EReg("^[A-Z]\\d+$", "");
	var lowerChar:EReg = new EReg("^[A-Z]\\d+$", "");

	public function new(font:String)
	{
		atlas = Paths.getSparrowAtlas('fonts/${font.toLowerCase()}');
		atlas.parent.destroyOnNoUse = false;
		atlas.parent.persist = true;

		for (i in atlas.frames)
		{
			maxHeight = Math.max(maxHeight, i.frame.height);

			var upperName = upperChar.match(i.name);
			var lowerName = lowerChar.match(i.name);

			if (lowerName != upperName)
				caseAllowed = upperName ? Upper : Lower;
		}
	}
}

class AtlasChar extends FlxSprite
{
	public var char:String;

	public function new(x:Float, y:Float, atlas:FlxFramesCollection, newChar:String)
	{
		super(x, y);

		frames = atlas;

		char = newChar;

		antialiasing = true;
	}

	function set_char(char:String)
	{
		if (char != this.char)
		{
			animation.addByPrefix('anim', getAnimPrefix(char), 24);
			animation.play('anim');
			updateHitbox();
		}

		return this.char = char;
	}

	function getAnimPrefix(anim:String)
	{
		switch (anim)
		{
			case "!":
				return "-exclamation point-";
			case "'":
				return "-apostraphie-";
			case "*":
				return "-multiply x-";
			case ",":
				return "-comma-";
			case "-":
				return "-dash-";
			case ".":
				return "-period-";
			case "/":
				return "-forward slash-";
			case "?":
				return "-question mark-";
			case "\\":
				return "-back slash-";
			case "\u201c":
				return "-start quote-";
			case "\u201d":
				return "-end quote-";
			default:
				return anim;
		}
	}
}
