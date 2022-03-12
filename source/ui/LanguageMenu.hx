package ui;

import mods.ModHandler;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class LanguageMenu extends ui.OptionsState.Page
{
    var grpLocales:LanguageMenuList;

	public function new():Void
	{
		super();

		grpLocales = new LanguageMenuList();
		add(grpLocales);

        var loopNum:Int = 0;

		for (locale in ModHandler.tongue.locales)
		{
            var thing = ModHandler.tongue.getIndexString(LanguageRegionNative, locale, ModHandler.tongue.locale);
			grpLocales.createItem(0, 10 + (40 * loopNum), thing, null, true);

			loopNum++;
		}
	}
}

class LanguageMenuList extends MenuTypedList
{
	public function createItem(x:Null<Float>, y:Null<Float>, name:String, callback:Void->Void, ?localeEnabled:Bool)
	{
		var menuItem = new LanguageMenuItem(x, y, name, callback);
		menuItem.fireInstantly = true;
		menuItem.localeEnabled = localeEnabled;
		menuItem.ID = length;

		return addItem(menuItem.name, menuItem);
	}
}

class LanguageMenuItem extends MenuItem
{
	public var localeEnabled(default, set):Bool = false;

	var label:FlxText;

	public function new(x:Float, y:Float, locale:String, callback:Void->Void)
	{
		label = new FlxText(x, y, 0, locale, 32);

		super(x, y, locale, callback);
	}

	function set_localeEnabled(value:Bool):Bool
	{
		localeEnabled = value;

		if (localeEnabled)
		{
			if (label != null)
				label.color = FlxColor.YELLOW;
		}
		else
		{
			if (label != null)
				label.color = FlxColor.WHITE;
		}

		return localeEnabled;
	}

	public override function draw()
	{
		super.draw();

		if (label != null)
		{
			label.cameras = cameras;
			label.scrollFactor.x = scrollFactor.x;
			label.scrollFactor.y = scrollFactor.y;
			scrollFactor.putWeak();
			label.draw();
		}
	}

	public override function idle():Void
	{
		alpha = 0.6;

		if (label != null)
			label.alpha = 0.6;
	}

	public override function select():Void
	{
		alpha = 1;

		if (label != null)
			label.alpha = 1;
	}
}
