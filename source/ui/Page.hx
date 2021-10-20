package ui;

import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSignal.FlxTypedSignal;

class Page extends FlxTypedGroup<Dynamic>
{
	public var enabled:Bool = true;
	public var canExit:Bool = true;
	public var onExit:FlxTypedSignal<Void->Void> = new FlxTypedSignal<Void->Void>();
	public var onSwitch:FlxTypedSignal<PageName->Void> = new FlxTypedSignal<PageName->Void>();

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
		if (PlayerSettings.player1.controls.BACK && canExit)
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

enum PageName
{
	Options;
	Controls;
	Colors;
	Mods;
	Preferences;
}
