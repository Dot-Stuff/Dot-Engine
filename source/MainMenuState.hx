package;

import ui.NavControls;
import ui.WrapMode;
import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import ui.AtlasMenuItem;
import flixel.FlxObject;
import ui.MenuTypedList;
import ui.PreferencesMenu;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end

class MainMenuState extends MusicBeatState
{
	var menuItems:MainMenuList;

	var bg:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		persistentUpdate = true;
		persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, 0.17);
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(bg.scrollFactor.x, bg.scrollFactor.y);
		magenta.setGraphicSize(Std.int(bg.width));
		magenta.updateHitbox();
		magenta.setPosition(bg.x, bg.y);
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new MainMenuList();
		add(menuItems);

		menuItems.onChange.add(onMenuItemChange);

		menuItems.onAcceptPress.add(function(listener:FlxSprite) {
			FlxFlicker.flicker(magenta, 1.1, 0.15, false, true);
		});

		menuItems.enabled = false;

		menuItems.createItem(null, null, 'story mode', function()
		{
			startExitState(new StoryMenuState());
		});

		menuItems.createItem(null, null, 'freeplay', function()
		{
			startExitState(new FreeplayState());
		});

		menuItems.createItem(null, null, 'donate', selectDonate, true);

		menuItems.createItem(null, null, 'options', function()
		{
			startExitState(new ui.PreferencesMenu());
		});

		var crap = (FlxG.height - 160 * (menuItems.length - 1)) / 2;
		for (i in 0...menuItems.length)
		{
			var member = menuItems.members[i];
			
			member.x = FlxG.width / 2;
			member.y = crap + 160 * i;
		}

		FlxG.camera.follow(camFollow, null, 0.6);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta['version'] + "(Dot Engine)", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	public override function finishTransIn()
	{
		super.finishTransIn();

		menuItems.enabled = true;
	}

	public function onMenuItemChange(listener:FlxSprite)
	{
		camFollow.setPosition(listener.getGraphicMidpoint().x, listener.getGraphicMidpoint().y);
	}

	function selectDonate()
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
		#else
		FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
		#end
	}

	public function startExitState(target:FlxState)
	{
		menuItems.enabled = false;
		menuItems.forEach(function(a:FlxSprite)
		{
			menuItems.selectedIndex != a.ID ? FlxTween.tween(a, { alpha: 0 }, 0.4, { ease: FlxEase.quadOut }) : a.visible = false;
		});

		new FlxTimer().start(0.4, function(b) 
		{
			FlxG.switchState(target);
		});
	}

	override function update(elapsed:Float)
	{
		FlxG.camera.followLerp = CoolUtil.camLerpShit(0.6);

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (_exiting)
			menuItems.enabled = false;

		if (controls.BACK && menuItems.enabled && !menuItems.busy)
			FlxG.switchState(new TitleState());

		super.update(elapsed);
	}
}

class MainMenuList extends MenuTypedList
{
	var atlas:FlxFramesCollection = Paths.getSparrowAtlas('main_menu');

	public function createItem(x:Float, y:Float, name:String, callback:Void->Void, ?fireInstantly:Bool):FlxSprite
	{
		var menuItem = new MainMenuItem(x, y, name, atlas, callback);
		menuItem.fireInstantly = fireInstantly;
		menuItem.ID = length;
		return addItem(name, menuItem);
	}

	public override function destroy()
	{
		super.destroy();
		atlas = null;
	}
}

class MainMenuItem extends AtlasMenuItem
{
	public function new(x:Float, y:Float, newName:String, newAtlas:FlxFramesCollection, newCallback:Void->Void)
	{
		super(x, y, newName, newAtlas, newCallback);

		scrollFactor.set();
	}

	public override function changeAnim(animName:String)
	{
		super.changeAnim(animName);

		origin.set(0.5 * frameWidth, 0.5 * frameHeight);

		origin.x += origin.x;
		origin.y += origin.y;

		origin.putWeak();
	}
}