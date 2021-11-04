package ui;

import flixel.util.FlxStringUtil;
import flixel.util.FlxStringUtil.LabelValuePair;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
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

class AtlasText extends FlxTypedSpriteGroup<AtlasChar>
{
	public var text(default, set):String = '';

	public var fonts:EnumValueMap<AtlasFont, AtlasFontData> = new EnumValueMap<AtlasFont, AtlasFontData>();
	public var font:AtlasFontData;

	public function new(x:Float, y:Float, name:String, atlasFont:AtlasFont = Default)
	{
		if (!fonts.exists(atlasFont))
			fonts.set(atlasFont, new AtlasFontData(atlasFont));

		font = fonts.get(atlasFont);

		super(x, y);

		text = name;
	}

	function set_text(name:String)
	{
		var nameCase = restrictCase(name);
		var textCase = restrictCase(text);

		text = name;

		if (nameCase == textCase)
			return text;
		if (nameCase.indexOf(textCase) == 0)
		{
			appendTextCased(nameCase.substr(textCase.length));
			return text;
		}

		text = nameCase;

		group.kill();

		if (text == "")
			return text;

		appendTextCased(nameCase);

		return text;
	}

	function restrictCase(textShit:String):String
	{
		return switch (font.caseAllowed)
		{
			case Both: textShit;
			case Upper: textShit.toUpperCase();
			case Lower: textShit.toLowerCase();
		}
	}

	function appendTextCased(name:String)
	{
		var living:Int = group.countLiving();
		var offsetX:Float = 0;
		var offsetY:Float = 0;

		if (living == -1)
			living = 0;
		else if (living > 0)
		{
			var thing = group.members[living - 1];
			offsetX = thing.x + thing.width - x;
			offsetY = thing.y + thing.height - font.maxHeight - y;
		}

		for (i in name.split(''))
		{
			switch (i)
			{
				case "\n":
					offsetX = 0;
					offsetY += font.maxHeight;
				case " ":
					offsetX += 40;
				default:
					var char:AtlasChar;

					if (living >= group.members.length)
						char = new AtlasChar(0, 0, font.atlas, i);
					else
					{
						char = group.members[living];
						char.revive();
						char.char = i;
						char.alpha = 1;
					}

					char.x = offsetX;
					char.y = offsetY + font.maxHeight + char.height;

					add(char);
					offsetX += char.width;

					living++;
			}
		}
	}

	public override function toString():String
	{
		return "InputItem, " + FlxStringUtil.getDebugString([
			LabelValuePair.weak("x", x),
			LabelValuePair.weak("y", y),
			LabelValuePair.weak("text", text),
		]);
	}
}

class AtlasFontData
{
	public var caseAllowed:Case = Both;
	public var maxHeight:Float = 0;

	public var atlas:FlxFramesCollection;

	var upperChar:EReg = new EReg("^[A-Z]\\d+$", "");
	var lowerChar:EReg = new EReg("^[A-Z]\\d+$", "");

	public function new(font:AtlasFont)
	{
		atlas = Paths.getSparrowAtlas('fonts/${font.getName().toLowerCase()}');
		atlas.parent.destroyOnNoUse = false;
		atlas.parent.persist = true;

		var upperName:Bool = false;
		var lowerName:Bool = false;

		for (i in atlas.frames)
		{
			maxHeight = Math.max(maxHeight, i.frame.height);

			if (upperName)
				upperName = upperChar.match(i.name);

			if (lowerName)
				lowerName = lowerChar.match(i.name);
		}

		if (lowerName != upperName)
			caseAllowed = upperName ? Upper : Lower;
	}
}

class AtlasChar extends FlxSprite
{
	public var char(default, set):String;

	public function new(x:Float, y:Float, atlas:FlxFramesCollection, newChar:String)
	{
		super(x, y);

		frames = atlas;

		char = newChar;

		antialiasing = true;
	}

	function set_char(char:String):String
	{
		if (this.char != char)
		{
			animation.addByPrefix('anim', getAnimPrefix(char), 24);
			animation.play('anim');
			updateHitbox();
		}

		return this.char = char;
	}

	function getAnimPrefix(anim:String):String
	{
		return switch (anim)
		{
			case "!": "-exclamation point-";
			case "'": "-apostraphie-";
			case "*": "-multiply x-";
			case ",": "-comma-";
			case "-": "-dash-";
			case ".": "-period-";
			case "/": "-forward slash-";
			case "?": "-question mark-";
			case "\\": "-back slash-";
			case "\u201c": "-start quote-";
			case "\u201d": "-end quote-";
			default: anim;
		}
	}
}
