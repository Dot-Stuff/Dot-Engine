package ui;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.ds.EnumValueMap;
import ui.Prompt.NgPrompt;
import ui.MenuTypedList.TextMenuList;

#if newgrounds
import io.newgrounds.NG;
#end

#if discord_rpc
import Discord.DiscordClient;
#end

enum PageName
{
	Options;
	Controls;
	Colors;
	Language;
	#if MODDING
	Mods;
	#end
	Preferences;
}

/**
 * TODO: Clear saved data button.
 */
class OptionsState extends MusicBeatState
{
	var currentName:PageName = Options;
	var pages:EnumValueMap<PageName, Page> = new EnumValueMap<PageName, Page>();

	public override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(mods.LocaleHandler.getTranslation("OPTIONS_MENU", "discord_rpc"), null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.loadImage('menuDesat'));
		bg.color = 0xFFEA71FD;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);

		var optionsPage:OptionsMenu = addPage(Options, new OptionsMenu(false));
		var prefsPage:PreferencesMenu = addPage(Preferences, new PreferencesMenu());
		#if mobile
		var controlsPage:MobileControlsMenu = addPage(Controls, new MobileControlsMenu());
		#else
		var controlsPage:ControlsMenu = addPage(Controls, new ControlsMenu());
		#end
		//var colorsPage:ColorsMenu = addPage(Colors, new ColorsMenu());
		var languagePage:LanguageMenu = addPage(Language, new LanguageMenu());
		#if MODDING
		var moddingPage:ModMenu = addPage(Mods, new ModMenu());
		#end

		if (optionsPage.hasMultipleOptions())
		{
			optionsPage.onExit.add(exitToMainMenu);

			controlsPage.onExit.add(function() {
				switchPage(Options);
			});

			prefsPage.onExit.add(function() {
				switchPage(Options);
			});

			/*colorsPage.onExit.add(function() {
				switchPage(Options);
			});*/

			languagePage.onExit.add(function() {
				if (!languagePage.localePreferencesChanged())
				{
					switchPage(Options);
					return;
				}

				languagePage.writeLocalePreferences();

				// Load any configured locale
				mods.LocaleHandler.loadLocale(FlxG.save.data.locale);

				FlxG.save.flush();

				FlxG.switchState(new InitState());
			});

			#if MODDING
			moddingPage.onExit.add(function() {
				if (moddingPage.modPreferencesChanged())
				{
					switchPage(Options);
					return;
				}

				moddingPage.writeModPreferences();

				// Load any configured mods
				mods.ModHandler.loadConfiguredMods();

				pages.get(currentName).enabled = false;

				FlxG.switchState(new InitState());
			});
			#end
		}
		else
		{
			controlsPage.onExit.add(exitToMainMenu);

			setPage(Controls);
		}

		pages.get(currentName).enabled = false;

		super.create();
	}

	public function addPage<T:Page>(pageName:PageName, page:T):T
	{
		page.onSwitch.add(switchPage);

		pages.set(pageName, page);
		add(page);

		page.exists = pageName == currentName;

		return page;
	}

	public function setPage(name:PageName)
	{
		if (pages.exists(currentName))
			pages.get(currentName).exists = false;

		currentName = name;

		if (pages.exists(currentName))
			pages.get(currentName).exists = true;
	}

	public override function finishTransIn()
	{
		super.finishTransIn();

		pages.get(currentName).enabled = true;
	}

	public function switchPage(page:PageName)
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		var pageName = mods.LocaleHandler.getTranslation(page.getName(), 'options');
		DiscordClient.changePresence(mods.LocaleHandler.getTranslationReplace("PAGE_X_MENU", ["X" => pageName], 'discord_rpc'), null);
		#end

		setPage(page);
	}

	public function exitToMainMenu()
	{
		pages.get(currentName).enabled = false;

		FlxG.switchState(new MainMenuState());
	}
}

class Page extends FlxGroup
{
	public var enabled(default, set):Bool = true;
	public var canExit:Bool = true;
	public var onExit:FlxTypedSignal<Void->Void> = new FlxTypedSignal<Void->Void>();
	public var onSwitch:FlxTypedSignal<PageName->Void> = new FlxTypedSignal<PageName->Void>();

	var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.players[0].controls;

	public function exit()
	{
		onExit.dispatch();
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (enabled)
			updateEnabled(elapsed);
	}

	public function updateEnabled(elapsed:Float)
	{
		if (canExit && controls.BACK)
		{
			FlxG.sound.play(Paths.sound("cancelMenu"));
			onExit.dispatch();
		}
	}

	public function set_enabled(val:Bool):Bool
	{
		return val == enabled;
	}

	public function openPrompt(target:FlxSubState, ?openCallback:Void->Void)
	{
		enabled = false;

		target.closeCallback = function()
		{
			enabled = true;

			if (openCallback != null)
				openCallback();
		}

		FlxG.state.openSubState(target);
	}
}

class OptionsMenu extends Page
{
	public var items:TextMenuList;

	public function new(canDonate:Bool)
	{
		super();

		items = new TextMenuList();
		add(items);

		createItem('preferences', function() {
			onSwitch.dispatch(Preferences);
		});

		createItem('controls', function() {
			onSwitch.dispatch(Controls);
		});

		/*createItem('colors', function() {
			onSwitch.dispatch(Colors);
		});*/

		createItem('language', function() {
			onSwitch.dispatch(Language);
		});

		#if MODDING
		createItem('mods', function() {
			onSwitch.dispatch(Mods);
		});
		#end

		if (canDonate)
			createItem('donate', selectDonate, true);

		#if newgrounds
		if (NG.core != null && NG.core.loggedIn)
			createItem('logout', selectLogout);
		else
			createItem('login', selectLogin);
		#end

		createItem('exit', exit);
	}

	public override function set_enabled(val:Bool):Bool
	{
		items.enabled = val;
		return super.set_enabled(val);
	}

	public function createItem(name:String, callback:Void->Void, ?fireInstantly:Bool)
	{
		// TODO: Create a refresh name function for translations.
		var item = items.createItem(0, 100 + 100 * items.length, mods.LocaleHandler.getTranslation(name, 'options'), Bold, callback, fireInstantly);
		item.screenCenter(X);

		return item;
	}

	public function hasMultipleOptions():Bool
	{
		return items.length > 2;
	}

	public function selectDonate()
	{
		#if linux
		Sys.command('xdg-open', ["https://ninja-muffin24.itch.io/funkin"]);
		#else
		FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
		#end
	}

	#if newgrounds
	public function selectLogin()
	{
		openNgPrompt(NgPrompt.showLogin());
	}

	public function selectLogout()
	{
		openNgPrompt(NgPrompt.showLogout());
	}
	#end

	public function openNgPrompt(target:FlxSubState, ?openCallback:Void->Void)
	{
		var whatever:Void->Void = checkLoginStatus;

		if (openCallback != null)
		{
			whatever = function() {
				checkLoginStatus();
				openCallback();
			}
		}

		openPrompt(target, openCallback);
	}

	public function checkLoginStatus()
	{
		var logout = items.has('logout');

		#if newgrounds
		if (!logout && NG.core != null)
		{
			if (!logout && NG.core.loggedIn && NG.core != null)
				items.resetItem('logout', 'login', selectLogin);
			else
				items.resetItem('login', 'logout', selectLogout);
		}
		#end
	}

	public override function openPrompt(target:FlxSubState, ?openCallback:Void->Void)
	{
		items.enabled = false;
		target.closeCallback = function()
		{
			items.enabled = true;

			if (openCallback != null)
				openCallback();
		}

		FlxG.state.openSubState(target);
	}
}
