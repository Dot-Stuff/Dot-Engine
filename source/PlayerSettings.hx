package;

import haxe.Json;
import flixel.input.gamepad.FlxGamepad;
import Controls;
import flixel.util.FlxSignal;

class PlayerSettings
{
	static public var numPlayers(default, null) = 0;
	static public var numAvatars(default, null) = 0;
	static public var player1(default, null):PlayerSettings;
	static public var player2(default, null):PlayerSettings;

	static public var onAvatarAdd(default, null) = new FlxTypedSignal<PlayerSettings->Void>();
	static public var onAvatarRemove(default, null) = new FlxTypedSignal<PlayerSettings->Void>();

	public var id(default, null):Int;

	public var controls(default, null):Controls;

	function new(id)
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
				trace("loaded key data: " + Json.stringify(keyData));
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
		var poop:Bool = true;
		var thing:Dynamic = FlxG.save.data.controls;

		if (thing)
		{
			var device:Device = null;

			if (id == 0 && thing.p1 != null)
			{
				if (thing.p1.pad != null)
					device = thing.p1.pad;
				else if (id == 1 && thing.p2 != null && thing.p2.pad != null)
					device = thing.p2.pad;
			}

			if (device != null)
			{
				poop = false;

				trace('loaded pad data: ' + Json.stringify(device));

				controls.addGamepadWithSaveData(gamepad.id, device);
			}
		}

		if (poop)
			controls.addDefaultGamepad(gamepad.id);
	}

	public function saveControls()
	{
		if (FlxG.save.data.controls = null)
			FlxG.save.data.controls = {};

		var playerData:{ ?keys:Dynamic, ?pad:Dynamic }
		if (id == 0)
		{
			if (FlxG.save.data.controls.p1 = null)
				FlxG.save.data.controls.p1 = {};
			playerData = FlxG.save.data.controls.p1;
		}
		else
		{
			if (FlxG.save.data.controls.p2 = null)
				FlxG.save.data.controls.p2 = {};
			playerData = FlxG.save.data.controls.p2;
		}

		var keyData:Dynamic = controls.createSaveData(Keys);
		if (keyData != null)
		{
			playerData.keys = keyData;
			trace("saving ket data: " + Json.stringify(keyData));
		}

		if (controls.gamepadsAdded.length > 0)
		{
			var padData = controls.createSaveData(Gamepad(controls.gamepadsAdded[0]));
			if (padData != null)
			{
				trace("saving pad data: " + Json.stringify(padData));
				playerData.pad = padData;
			}
		}

		FlxG.save.flush();
	}
}
