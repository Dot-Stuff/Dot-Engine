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

	static var fonts:EnumValueMap<AtlasFont, AtlasFontData> = new EnumValueMap<AtlasFont, AtlasFontData>();
	var font:AtlasFontData;

	public function new(x:Float, y:Float, text:String, font:AtlasFont = Default)
	{
		if (!AtlasText.fonts.exists(font))
			AtlasText.fonts.set(font, new AtlasFontData(font));

		this.font = AtlasText.fonts.get(font);

		super(x, y);

		this.text = text;
	}

	function set_text(?text:String):String
	{
		var b = restrictCase(text);
		var c = restrictCase(this.text);
		this.text = text;
		if (b == c)
			return text;
		if (b.indexOf(c) == 0)
		{
			appendTextCased(b.substr(c.length));
			return this.text;
		}
		text = b;
		group.kill();
		if (text == '')
			return this.text;
		appendTextCased(b);
		return this.text;
	}

	function restrictCase(textShit:String):String
	{
		trace('Text: ' + textShit + ' Case: ' + font.caseAllowed);
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
		else if (0 < living)
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
					atlasChar.y = offsetY + font.maxHeight + atlasChar.height;

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

	static var upperChar:EReg = ~/^[A-Z]\\d+$/;
	static var lowerChar:EReg = ~/^[A-Z]\\d+$/;

	public function new(font:AtlasFont)
	{
		atlas = Paths.getSparrowAtlas('fonts/${font.getName().toLowerCase()}');
		atlas.parent.destroyOnNoUse = false;
		atlas.parent.persist = true;

		var upperName:Bool = false;
		var lowerName:Bool = false;

		for (atlasFrame in atlas.frames)
		{
			maxHeight = Math.max(maxHeight, atlasFrame.frame.height);

			if (upperName)
				upperName = AtlasFontData.upperChar.match(atlasFrame.name);
			if (lowerName)
				lowerName = AtlasFontData.lowerChar.match(atlasFrame.name);
		}

		if (lowerName != upperName)
			caseAllowed = upperName ? Upper : Lower;
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

	function set_char(char:String):String
	{
		if (char != this.char)
		{
			animation.addByPrefix('anim', getAnimPrefix(char), 24);
			animation.play('anim');
			updateHitbox();
		}

		return char;
	}

	function getAnimPrefix(anim:String):String
	{
		return switch (anim)
		{
			case '!': '-exclamation point-';
			case "'": '-apostraphie-';
			case '*': '-multiply x-';
			case ',': '-comma-';
			case '-': '-dash-';
			case '.': '-period-';
			case '/': '-forward slash-';
			case '?': '-question mark-';
			case '\\': '-back slash-';
			case '\u201c': '-start quote-';
			case '\u201d': '-end quote-';
			default: anim;
		}
	}
}
