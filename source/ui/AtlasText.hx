package ui;

import flixel.graphics.frames.FlxFramesCollection;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
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

class AtlasText extends FlxTypedSpriteGroup<FlxSprite>
{
    public var text:String = '';

    public var fonts:EnumValueMap<AtlasFont, AtlasFontData> = new EnumValueMap<AtlasFont, AtlasFontData>();

    public function new(x:Float, y:Float, name:String, atlasFont:AtlasFont = Default)
    {
        if (!fonts.exists(atlasFont))
            fonts.set(atlasFont, new AtlasFontData(atlasFont.getName()));

        super(x, y);

        set_text(name);
    }

    public function set_text(name:String)
    {
        return text;
    }
}

class AtlasFontData
{
    var caseAllowed:Case = Both;
    var maxHeight:Float = 0;

    var atlas:FlxFramesCollection;

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
