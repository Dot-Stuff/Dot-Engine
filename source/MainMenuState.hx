package;

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
import ui.MenuState;

using StringTools;

#if discord_rpc
import Discord.DiscordClient;
#end

class MainMenuState extends MenuState
{
	public var menuItems:FlxTypedGroup<MainMenuList>;

	private var bg:FlxSprite;
	private var magenta:FlxSprite;

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

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta['version'] + "(Dot Engine)", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();

		menuItems = new FlxTypedGroup<MainMenuList>();
		add(menuItems);

		createItem('story mode', function()
		{
			FlxG.switchState(new StoryMenuState());
		});

		createItem('freeplay', function()
		{
			FlxG.switchState(new FreeplayState());
		});

		createItem('donate', selectDonate, true);

		createItem('options', function()
		{
			FlxG.switchState(new ui.MultiplayerMenu());
		});

		for (i in 0...items.length)
		{
			var menuItem:MainMenuList = new MainMenuList(0, 60 + (i * 160), items[i].name);
			menuItem.idle();
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
		}

		changeItem();
	}

	function selectDonate()
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
		#else
		FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
		#end
	}

	override function update(elapsed:Float)
	{
		FlxG.camera.followLerp = CoolUtil.camLerpShit(0.6);

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		super.update(elapsed);

		menuItems.forEach(function(spr:MainMenuList)
		{
			spr.screenCenter(X);
		});
	}

	public override function changeItem(change:Int = 0)
	{
		super.changeItem(change);

		if (curSelected >= menuItems.length)
			curSelected = 0;
		else if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:MainMenuList)
		{
			spr.idle();

			if (spr.ID == curSelected)
			{
				spr.select();
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
		});
	}

	public override function acceptItem()
	{
		super.acceptItem();

		FlxFlicker.flicker(magenta, 1.1, 0.15, false, true);

		menuItems.forEach(function(spr:MainMenuList)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					items[curSelected].onAccept();
				});
			}
		});
	}
}

class MainMenuList extends FlxSprite
{
	var atlas:FlxFramesCollection;

	public function new(x:Float, y:Float, name:String):Void
	{
		super(x, y);

		frames = atlas = Paths.getSparrowAtlas('main_menu');
		animation.addByPrefix('idle', '$name idle', 24);
		animation.addByPrefix('selected', '$name selected', 24);

		antialiasing = true;
	}

	public override function destroy():Void
	{
		super.destroy();

		atlas = null;
	}

	function changeAnim(name:String)
	{
		animation.play(name);
		updateHitbox();
	}

	public function idle()
	{
		changeAnim("idle");
	}

	public function select()
	{
		changeAnim("selected");
	}

	/*public function createItem(a, b, c, d, e):Void
	{
		if (e == null)
		{
			if (b == null)
			{
				a.ID = length;
			}
		}
}*/}
