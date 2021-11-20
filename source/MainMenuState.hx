package;

import ui.Prompt;
import flixel.FlxSubState;
import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.FlxObject;
import ui.MenuTypedList;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

#if newgrounds
import io.newgrounds.NG;
#end

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

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

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

		/*menuItems.createItem(0, 0, 'multiplayer', function()
		{
			startExitState(new netTest.MultiplayerMenu());
		});*/

		menuItems.createItem(0, 0, 'story mode', function()
		{
			startExitState(new StoryMenuState());
		});

		menuItems.createItem(0, 0, 'freeplay', function()
		{
			startExitState(new FreeplayState());
		});

		#if !switch
		menuItems.createItem(0, 0, 'donate', selectDonate, true);

		menuItems.createItem(0, 0, 'options', function()
		{
			startExitState(new ui.OptionsState());
		});
		#end

		var crap = (FlxG.height - 160 * (menuItems.length - 1)) / 2;
		for (i in 0...menuItems.length)
		{
			var member = menuItems.members[i];
			
			member.x = FlxG.width / 2;
			member.y = crap + 160 * i;
		}

		FlxG.camera.follow(camFollow, null, 0.6);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, 'v${Application.current.meta['version']}(Dot Engine)', 12);
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
		Sys.command('xdg-open', ["https://ninja-muffin24.itch.io/funkin"]);
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
		var logout = menuItems.has('logout');

		if (!logout && NG.core != null)
		{
			if (!logout && NG.core.loggedIn && NG.core != null)
				menuItems.resetItem('logout', 'login', selectLogin);
			else
				menuItems.resetItem('login', 'logout', selectLogout);
		}
	}

	public function openPrompt(target:FlxSubState, ?openCallback:Void->Void)
	{
		menuItems.enabled = false;
		target.closeCallback = function()
		{
			menuItems.enabled = true;

			if (openCallback != null)
				openCallback();
		}

		openSubState(target);
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
		FlxG.camera.followLerp = CoolUtil.camLerpShit(0.06);

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (_exiting)
			menuItems.enabled = false;

		if (controls.BACK && menuItems.enabled && !menuItems.busy)
			FlxG.switchState(new TitleState());

		super.update(elapsed);
	}
}

class MainMenuList extends ui.MenuTypedList
{
	var atlas:FlxFramesCollection = Paths.getSparrowAtlas('main_menu');

	public function createItem(x:Float, y:Float, name:String, callback:Void->Void, ?fireInstantly:Bool)
	{
		var menuItem = new MainMenuItem(x, y, name, atlas, callback);
		menuItem.fireInstantly = fireInstantly;
		menuItem.ID = length;
		return addItem(name, menuItem);
	}
}

class MainMenuItem extends AtlasMenuItem
{
	public function new(x:Float, y:Float, newName:String, atlas:FlxFramesCollection, callback:Void->Void)
	{
		super(x, y, newName, atlas, callback);

		scrollFactor.set();
	}

	public override function changeAnim(animName:String)
	{
		super.changeAnim(animName);

		origin.set(frameWidth * 0.5, frameHeight * 0.5);

		offset.x = origin.x;
		offset.y = origin.y;

		origin.putWeak();
	}
}

class AtlasMenuItem extends ui.MenuItem
{
	var atlas:FlxFramesCollection;

	public function new(x:Float, y:Float, name:String, atlas:FlxFramesCollection, callback:Void->Void):Void
	{
		this.atlas = atlas;

		super(x, y, name, callback);
	}

	public override function setData(name:String, callback:Void->Void):Void
	{
		frames = atlas;
		animation.addByPrefix('idle', name + ' idle', 24);
		animation.addByPrefix('selected', name + ' selected', 24);

		super.setData(name, callback);
	}

	public function changeAnim(name:String):Void
	{
		animation.play(name);
		updateHitbox();
	}

	public override function idle():Void
	{
		changeAnim('idle');
	}

	public override function select():Void
	{
		changeAnim('selected');
	}

	public override function get_selected():Bool
	{
		return animation.curAnim != null ? animation.curAnim.name == 'selected' : false;
	}
}
