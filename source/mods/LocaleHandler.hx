package mods;

import firetongue.FireTongue;
import firetongue.Replace;

using StringTools;

class LocaleHandler
{
	public static var tongue:FireTongue;

	/**
	 * Loads all mods
	 * Saves the mods as well
	 */
	public static function init()
	{
		loadLocale(getConfiguredLocale());
	}

	public static function loadLocale(locale:String)
	{
		if (tongue == null)
			tongue = new FireTongue();

		tongue.initialize({
			locale: locale,
			directory: 'locales/',
		});
	}

	public static function getConfiguredLocale():String
	{
		var rawSaveData = FlxG.save.data.locale;

		if (rawSaveData != null)
			return rawSaveData;

		return FireTongue.defaultLocale;
	}

	public static function getTranslation(flag:String, context:String = "data"):String
	{
		return tongue.get(flag.toUpperCase().replace(' ', '_'), context);
	}

	public static function getTranslationReplace(flag:String, context:String = "data", flags:Array<String>, values:Array<String>):String
	{
		var str = getTranslation(flag, context);
		str = Replace.flags(str, flags, values);
		return str;
	}
}
