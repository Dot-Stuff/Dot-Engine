package ui;

import mods.LocaleHandler;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class LanguageMenu extends ui.OptionsState.Page
{
    var grpLocales:LanguageMenuList;

	var selectedLocale:String;

	public function new():Void
	{
		super();

		selectedLocale = LocaleHandler.tongue.locale;

		grpLocales = new LanguageMenuList();
		add(grpLocales);

        var loopNum:Int = 0;

		for (i in LocaleHandler.tongue.locales)
		{
			var locale = LocaleHandler.tongue.getIndexString(LanguageNative, i, LocaleHandler.tongue.locale);
			var item = grpLocales.createItem(null, null, locale, function()
			{
				selectedLocale = i;
			}, FlxG.save.data.locale == i);
			item.screenCenter();
			item.y += (40 * loopNum);

			loopNum++;
		}
	}

	public function writeLocalePreferences()
	{
		FlxG.save.data.locale = selectedLocale;
		FlxG.save.flush();
	}

	public function localePreferencesChanged():Bool
	{
		return FlxG.save.data.locale != selectedLocale;
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
			label.x = x;
			label.y = y;
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
