package ui;

import ui.Page.PageName;
import io.newgrounds.NG;
import flixel.util.FlxAxes;
import ui.TextMenuList.TextMenuItem;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;
import flixel.FlxSprite;
import haxe.ds.EnumValueMap;

/**
 * TODO: Clear saved data button.
 */
class OptionsState extends MusicBeatState
{
	var currentName:PageName = PageName.Options;
	var pages:EnumValueMap<PageName, Page> = new EnumValueMap<PageName, Page>();

	function get_currentPage()
	{
		return pages.get(currentName);
	}

	public override function create()
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('menuDesat'));
		bg.color = -1412611;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);

		var optionsPage = addPage(Options, new OptionsMenu());
		var prefsPage = addPage(Preferences, new PreferencesMenu());
		var controlsPage = addPage(Controls, new ControlsMenu());

		if (optionsPage.hasMultipleOptions())
		{
			optionsPage.onExit.add(exitToMainMenu);

			controlsPage.onExit.add(function() {
				switchPage(Options);
			});

			prefsPage.onExit.add(function() {
				switchPage(Options);
			});
		}
		else
		{
			optionsPage.onExit.add(exitToMainMenu);
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

		return page;
	}

	public function setPage(name:PageName)
	{
		if (pages.exists(currentName))
			pages.get(currentName).enabled = false;

		currentName = name;

		if (pages.exists(currentName))
			pages.get(currentName).enabled = true;
	}

	public override function finishTransIn()
	{
		super.finishTransIn();
		pages.get(currentName).enabled = true;
	}

	public function switchPage(page:PageName)
	{
		setPage(page);
	}

	public function exitToMainMenu()
	{
		pages.get(currentName).enabled = false;

		FlxG.switchState(new MainMenuState());
	}
}

class OptionsMenu extends Page
{
	public var items:TextMenuList;

	public function new()
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

		createItem('donate', selectDonate, true);
	}

	public function createItem(name:String, callback:Void->Void, ?fireInstantly:Bool)
	{
		var item:TextMenuItem = items.createItem(0, 100 + 100 * items.length, name, Bold, callback);
		item.fireInstantly = fireInstantly;
		item.screenCenter(FlxAxes.X);

		return item;
	}

	public function hasMultipleOptions():Bool
	{
		return items.length > 2;
	}

	public function selectDonate()
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
		#else
		FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
		#end
	}

	public function selectLogin()
	{
		openNgPrompt(NgPrompt.showLogin());
	}

	public function selectLogout()
	{
		openNgPrompt(NgPrompt.showLogin());
	}

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

		if (!logout && NG.core != null)
		{
			if (!logout && NG.core.loggedIn && NG.core != null)
				items.resetItem('logout', 'login', selectLogin);
			else
				items.resetItem('login', 'logout', selectLogout);
		}
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

