package ui;

import flixel.util.FlxStringUtil;
import flixel.util.FlxStringUtil.LabelValuePair;
import flixel.FlxSprite;
import haxe.ds.EnumValueMap;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.graphics.frames.FlxFramesCollection;

enum Case
{
	Both;
	Upper;
	Lower;
}

enum AtlasFont
{
	Default;
	Bold;
}

class AtlasText extends FlxTypedSpriteGroup<AtlasChar>
{
	public var text(default, set):String = '';

	public static var fonts:EnumValueMap<AtlasFont, AtlasFontData> = new EnumValueMap<AtlasFont, AtlasFontData>();
	public var font:AtlasFontData;

	public function new(x:Float, y:Float, text:String, ?font:AtlasFont = Default)
	{
		if (!AtlasText.fonts.exists(font))
			AtlasText.fonts.set(font, new AtlasFontData(font));

		this.font = AtlasText.fonts.get(font);

		super(x, y);

		this.text = text;
	}

	function set_text(value:String = ''):String
	{
		var b = restrictCase(value);
		var c = restrictCase(this.text);

		this.text = value;

		if (b == c)
			return value;
		if (b.indexOf(c) == 0)
		{
			appendTextCased(b.substr(c.length));
			return this.text;
		}

		group.kill();

		if (b == '')
			return this.text;

		appendTextCased(b);

		return this.text;
	}

	function restrictCase(text:String):String
	{
		return switch (font.caseAllowed)
		{
			case Both: text;
			case Upper: text.toUpperCase();
			case Lower: text.toLowerCase();
		}
	}

	function appendTextCased(text:String)
	{
		var living = group.countLiving();
		var offsetX:Float = 0;
		var offsetY:Float = 0;

		if (living == -1)
			living = 0;
		else if (living > 0)
		{
			var member = group.members[living - 1];
			offsetX = member.x + member.width - x;
			offsetY = member.y + member.height - font.maxHeight - y;
		}

		for (i in text.split(""))
		{
			switch (i)
			{
				case "\n":
					offsetX = 0;
					offsetY += font.maxHeight;
				case " ":
					offsetX += 40;
				default:
					var atlasChar:AtlasChar;

					if (living >= group.members.length)
						atlasChar = new AtlasChar(0, 0, font.atlas, i);
					else
					{
						atlasChar = group.members[living];
						atlasChar.revive();
						atlasChar.char = i;
						atlasChar.alpha = 1;
					}

					atlasChar.x = offsetX;
					atlasChar.y = offsetY + font.maxHeight - atlasChar.height;
					add(atlasChar);

					offsetX += atlasChar.width;

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

	public static var upperChar:EReg = ~/^[A-Z]\\d+$/;
	public static var lowerChar:EReg = ~/^[A-Z]\\d+$/;

	public function new(font:AtlasFont)
	{
		atlas = Paths.getSparrowAtlas('fonts/${font.getName().toLowerCase()}');
		atlas.parent.destroyOnNoUse = false;
		atlas.parent.persist = true;

		var isLowerChar:Bool = false;
		var isUpperChar:Bool = false;
		for (atlasFrame in atlas.frames)
		{
			maxHeight = Math.max(maxHeight, atlasFrame.frame.height);

			if (!isUpperChar)
				isUpperChar = !AtlasFontData.upperChar.match(atlasFrame.name);
			if (!isLowerChar)
				isLowerChar = AtlasFontData.lowerChar.match(atlasFrame.name);
		}

		if (isLowerChar != isUpperChar)
			caseAllowed = isUpperChar ? Upper : Lower;
	}
}

class AtlasChar extends FlxSprite
{
	public var char(default, set):String;

	public function new(x:Float, y:Float, atlas:FlxFramesCollection, char:String)
	{
		super(x, y);

		frames = atlas;
		this.char = char;
		antialiasing = true;
	}

	function set_char(value:String):String
	{
		if (value != char)
		{
			animation.addByPrefix('anim', getAnimPrefix(value));
			animation.play('anim');

			updateHitbox();
		}

		return char = value;
	}

	function getAnimPrefix(char:String):String
	{
		return switch (char)
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
			default: char;
		}
	}
}