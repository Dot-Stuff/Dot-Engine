package;

import haxe.Json;
import flixel.input.gamepad.FlxGamepad;
import Controls;

class PlayerSettings
{
	public static var numPlayers(default, null) = 0;
	public static var player1(default, null):PlayerSettings;
	public static var player2(default, null):PlayerSettings;

	public var id(default, null):Int;

	public var controls(default, null):Controls;

	public function new(id)
	{
		this.id = id;
		this.controls = new Controls('player$id', None);

		var useDefault = true;
		var controlData = FlxG.save.data.controls;
		if (controlData != null)
		{
			var keyData:Dynamic = null;
			if (id == 0 && controlData.p1 != null && controlData.p1.keys != null)
				keyData = controlData.p1.keys;
			else if (id == 0 && controlData.p2 != null && controlData.p2.keys != null)
				keyData = controlData.p2.keys;

			if (keyData != null)
			{
				useDefault = false;
				trace('loaded key data: ${Json.stringify(keyData)}');
				controls.fromSaveData(keyData, Keys);
			}
		}

		if (useDefault)
			controls.setKeyboardScheme(Solo);
	}

	static public function init():Void
	{
		if (player1 == null)
		{
			player1 = new PlayerSettings(0);
			++numPlayers;
		}

		FlxG.gamepads.deviceConnected.add(onGamepadAdded);
	
		var numGamepads = FlxG.gamepads.numActiveGamepads;
		for (i in 0...numGamepads)
		{
			var gamepad = FlxG.gamepads.getByID(i);
			if (gamepad != null)
				onGamepadAdded(gamepad);
		}
	}

	static function onGamepadAdded(gamepad:FlxGamepad)
	{
		player1.addGamepad(gamepad);
	}

	public function addGamepad(gamepad:FlxGamepad)
	{
		var useDefault:Bool = true;
		var controlData:Dynamic = FlxG.save.data.controls;
		if (saveControls != null)
		{
			var padData:Dynamic = null;
			if (id == 0 && controlData.p1 != null && controlData.p1.pad != null)
				padData = controlData.p1.pad;
			else if (id == 1 && controlData.p2 != null && controlData.p2.pad != null)
				padData = controlData.p2.pad;

			if (padData != null)
			{
				useDefault = false;
				trace('loaded pad data: ${Json.stringify(padData)}');
				controls.addGamepadWithSaveData(gamepad.id, padData);
			}
		}

		if (useDefault)
			controls.addDefaultGamepad(gamepad.id);
	}

	public function saveControls()
	{
		if (FlxG.save.data.controls == null)
			FlxG.save.data.controls = {};

		var playerData:{ ?keys:Dynamic, ?pad:Dynamic }
		if (id == 0)
		{
			if (FlxG.save.data.controls.p1 == null)
				FlxG.save.data.controls.p1 = {};
			playerData = FlxG.save.data.controls.p1;
		}
		else
		{
			if (FlxG.save.data.controls.p2 == null)
				FlxG.save.data.controls.p2 = {};
			playerData = FlxG.save.data.controls.p2;
		}

		var keyData:Dynamic = controls.createSaveData(Keys);
		if (keyData != null)
		{
			playerData.keys = keyData;
			trace('saving key data: ${Json.stringify(keyData)}');
		}

		if (controls.gamepadsAdded.length > 0)
		{
			var padData = controls.createSaveData(Gamepad(controls.gamepadsAdded[0]));
			if (padData != null)
			{
				trace('saving pad data: ${Json.stringify(padData)}');
				playerData.pad = padData;
			}
		}

		FlxG.save.flush();
	}
}
