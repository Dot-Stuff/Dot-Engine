package;

import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

enum abstract Action(String) to String from String
{
	var UI_UP = "ui_up";
	var UI_LEFT = "ui_left";
	var UI_RIGHT = "ui_right";
	var UI_DOWN = "ui_down";
	var UI_UP_P = "ui_up-press";
	var UI_LEFT_P = "ui_left-press";
	var UI_RIGHT_P = "ui_right-press";
	var UI_DOWN_P = "ui_down-press";
	var UI_UP_R = "ui_up-release";
	var UI_LEFT_R = "ui_left-release";
	var UI_RIGHT_R = "ui_right-release";
	var UI_DOWN_R = "ui_down-release";
	var NOTE_UP = "note_up";
	var NOTE_LEFT = "note_left";
	var NOTE_RIGHT = "note_right";
	var NOTE_DOWN = "note_down";
	var NOTE_UP_P = "note_up-press";
	var NOTE_LEFT_P = "note_left-press";
	var NOTE_RIGHT_P = "note_right-press";
	var NOTE_DOWN_P = "note_down-press";
	var NOTE_UP_R = "note_up-release";
	var NOTE_LEFT_R = "note_left-release";
	var NOTE_RIGHT_R = "note_right-release";
	var NOTE_DOWN_R = "note_down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	#if CAN_CHEAT
	var CHEAT = "cheat";
	#end
}

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	NOTE_UP;
	NOTE_LEFT;
	NOTE_RIGHT;
	NOTE_DOWN;
	UI_UP;
	UI_LEFT;
	UI_RIGHT;
	UI_DOWN;
	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	#if CAN_CHEAT
	CHEAT;
	#end
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class Controls extends FlxActionSet
{
	var _uiup = new FlxActionDigital(Action.UI_UP);
	var _uileft = new FlxActionDigital(Action.UI_LEFT);
	var _uiright = new FlxActionDigital(Action.UI_RIGHT);
	var _uidown = new FlxActionDigital(Action.UI_DOWN);
	var _uiupP = new FlxActionDigital(Action.UI_UP_P);
	var _uileftP = new FlxActionDigital(Action.UI_LEFT_P);
	var _uirightP = new FlxActionDigital(Action.UI_RIGHT_P);
	var _uidownP = new FlxActionDigital(Action.UI_DOWN_P);
	var _uiupR = new FlxActionDigital(Action.UI_UP_R);
	var _uileftR = new FlxActionDigital(Action.UI_LEFT_R);
	var _uirightR = new FlxActionDigital(Action.UI_RIGHT_R);
	var _uidownR = new FlxActionDigital(Action.UI_DOWN_R);

	var _noteup = new FlxActionDigital(Action.NOTE_UP);
	var _noteleft = new FlxActionDigital(Action.NOTE_LEFT);
	var _noteright = new FlxActionDigital(Action.NOTE_RIGHT);
	var _notedown = new FlxActionDigital(Action.NOTE_DOWN);
	var _noteupP = new FlxActionDigital(Action.NOTE_UP_P);
	var _noteleftP = new FlxActionDigital(Action.NOTE_LEFT_P);
	var _noterightP = new FlxActionDigital(Action.NOTE_RIGHT_P);
	var _notedownP = new FlxActionDigital(Action.NOTE_DOWN_P);
	var _noteupR = new FlxActionDigital(Action.NOTE_UP_R);
	var _noteleftR = new FlxActionDigital(Action.NOTE_LEFT_R);
	var _noterightR = new FlxActionDigital(Action.NOTE_RIGHT_R);
	var _notedownR = new FlxActionDigital(Action.NOTE_DOWN_R);

	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _back = new FlxActionDigital(Action.BACK);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _reset = new FlxActionDigital(Action.RESET);
	#if CAN_CHEAT
	var _cheat = new FlxActionDigital(Action.CHEAT);
	#end

	var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.None;

	// UI
	public var UI_UP(get, never):Bool;

	inline function get_UI_UP()
		return _uiup.check();

	public var UI_LEFT(get, never):Bool;

	inline function get_UI_LEFT()
		return _uileft.check();

	public var UI_RIGHT(get, never):Bool;

	inline function get_UI_RIGHT()
		return _uiright.check();

	public var UI_DOWN(get, never):Bool;

	inline function get_UI_DOWN()
		return _uidown.check();

	public var UI_UP_P(get, never):Bool;

	inline function get_UI_UP_P()
		return _uiupP.check();

	public var UI_LEFT_P(get, never):Bool;

	inline function get_UI_LEFT_P()
		return _uileftP.check();

	public var UI_RIGHT_P(get, never):Bool;

	inline function get_UI_RIGHT_P()
		return _uirightP.check();

	public var UI_DOWN_P(get, never):Bool;

	inline function get_UI_DOWN_P()
		return _uidownP.check();

	public var UI_UP_R(get, never):Bool;

	inline function get_UI_UP_R()
		return _uiupR.check();

	public var UI_LEFT_R(get, never):Bool;

	inline function get_UI_LEFT_R()
		return _uileftR.check();

	public var UI_RIGHT_R(get, never):Bool;

	inline function get_UI_RIGHT_R()
		return _uirightR.check();

	public var UI_DOWN_R(get, never):Bool;

	inline function get_UI_DOWN_R()
		return _uidownR.check();

	// Note
	public var NOTE_UP(get, never):Bool;

	inline function get_NOTE_UP()
		return _noteup.check();

	public var NOTE_LEFT(get, never):Bool;

	inline function get_NOTE_LEFT()
		return _noteleft.check();

	public var NOTE_RIGHT(get, never):Bool;

	inline function get_NOTE_RIGHT()
		return _noteright.check();

	public var NOTE_DOWN(get, never):Bool;

	inline function get_NOTE_DOWN()
		return _notedown.check();

	public var NOTE_UP_P(get, never):Bool;

	inline function get_NOTE_UP_P()
		return _noteupP.check();

	public var NOTE_LEFT_P(get, never):Bool;

	inline function get_NOTE_LEFT_P()
		return _noteleftP.check();

	public var NOTE_RIGHT_P(get, never):Bool;

	inline function get_NOTE_RIGHT_P()
		return _noterightP.check();

	public var NOTE_DOWN_P(get, never):Bool;

	inline function get_NOTE_DOWN_P()
		return _notedownP.check();

	public var NOTE_UP_R(get, never):Bool;

	inline function get_NOTE_UP_R()
		return _noteupR.check();

	public var NOTE_LEFT_R(get, never):Bool;

	inline function get_NOTE_LEFT_R()
		return _noteleftR.check();

	public var NOTE_RIGHT_R(get, never):Bool;

	inline function get_NOTE_RIGHT_R()
		return _noterightR.check();

	public var NOTE_DOWN_R(get, never):Bool;

	inline function get_NOTE_DOWN_R()
		return _notedownR.check();

	// Etc
	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return _accept.check();

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return _back.check();

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return _pause.check();

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return _reset.check();

	#if CAN_CHEAT
	public var CHEAT(get, never):Bool;

	inline function get_CHEAT()
		return _cheat.check();
	#end

	public function new(name, scheme = None)
	{
		super(name);

		add(_uiup);
		add(_uileft);
		add(_uiright);
		add(_uidown);
		add(_uiupP);
		add(_uileftP);
		add(_uirightP);
		add(_uidownP);
		add(_uiupR);
		add(_uileftR);
		add(_uirightR);
		add(_uidownR);

		add(_noteup);
		add(_noteleft);
		add(_noteright);
		add(_notedown);
		add(_noteupP);
		add(_noteleftP);
		add(_noterightP);
		add(_notedownP);
		add(_noteupR);
		add(_noteleftR);
		add(_noterightR);
		add(_notedownR);

		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		#if CAN_CHEAT
		add(_cheat);
		#end

		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}

	public function fromSaveData(keyData:Dynamic, keys:Device)
	{
		for (i in Control.createAll())
		{
			var key:Dynamic = Reflect.field(keyData, i.getName());

			if (key != null)
			{
				switch (keys)
				{
					case Keys:
						bindKeys(i, key);
					case Gamepad(id):
						//bindButtons(i, id, key);
				}
			}
		}
	}

	public function createSaveData(device:Device):Dynamic
	{
		var b:Bool = true;

		//  {"NOTE_LEFT":[87,37],"NOTE_DOWN":[83,40],"NOTE_UP":[65,38],"NOTE_RIGHT":[68,39],"UI_UP":[87,38],"UI_LEFT":[65,37],"UI_RIGHT":[68,39],"UI_DOWN":[83,40],"RESET":[82],"ACCEPT":[90,32,13],"BACK":[88,8,27],"PAUSE":[80,13,27]}
		var controlData:Dynamic = {};

		for (i in Control.createAll())
		{
			var h = getInputsFor(i, device);
			b = b && h.length == 0;

			controlData[i.getIndex()] = h;
			trace('name: ${i.getName()} inputs: ${h}');
		}

		return b ? null : controlData;
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
			case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UI_UP: _uiup;
			case UI_DOWN: _uidown;
			case UI_LEFT: _uileft;
			case UI_RIGHT: _uiright;
			case NOTE_UP: _noteup;
			case NOTE_DOWN: _notedown;
			case NOTE_LEFT: _noteleft;
			case NOTE_RIGHT: _noteright;
			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
			#if CAN_CHEAT
			case CHEAT: _cheat;
			#end
		}
	}

	static function init():Void
	{
		FlxG.inputs.add(new FlxActionManager());
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case UI_UP:
				func(_uiup, PRESSED);
				func(_uiupP, JUST_PRESSED);
				func(_uiupR, JUST_RELEASED);
			case UI_LEFT:
				func(_uileft, PRESSED);
				func(_uileftP, JUST_PRESSED);
				func(_uileftR, JUST_RELEASED);
			case UI_RIGHT:
				func(_uiright, PRESSED);
				func(_uirightP, JUST_PRESSED);
				func(_uirightR, JUST_RELEASED);
			case UI_DOWN:
				func(_uidown, PRESSED);
				func(_uidownP, JUST_PRESSED);
				func(_uidownR, JUST_RELEASED);
			case NOTE_UP:
				func(_noteup, PRESSED);
				func(_noteupP, JUST_PRESSED);
				func(_noteupR, JUST_RELEASED);
			case NOTE_LEFT:
				func(_noteleft, PRESSED);
				func(_noteleftP, JUST_PRESSED);
				func(_noteleftR, JUST_RELEASED);
			case NOTE_RIGHT:
				func(_noteright, PRESSED);
				func(_noterightP, JUST_PRESSED);
				func(_noterightR, JUST_RELEASED);
			case NOTE_DOWN:
				func(_notedown, PRESSED);
				func(_notedownP, JUST_PRESSED);
				func(_notedownR, JUST_RELEASED);
			case ACCEPT:
				func(_accept, JUST_PRESSED);
			case BACK:
				func(_back, JUST_PRESSED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
			case RESET:
				func(_reset, JUST_PRESSED);
			#if CAN_CHEAT
			case CHEAT:
				func(_cheat, JUST_PRESSED);
			#end
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}

		switch (device)
		{
			case null:
				// add all
				for (gamepad in controls.gamepadsAdded)
					if (!gamepadsAdded.contains(gamepad))
						gamepadsAdded.push(gamepad);

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			keyboardScheme = switch (keyboardScheme)
			{
				case None: scheme;
				default: Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addKeys(action, keys, state));
		#else
		forEachBound(control, function(action, state) addKeys(action, keys, state));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeKeys(action, keys));
		#else
		forEachBound(control, function(action, _) removeKeys(action, keys));
		#end
	}

	inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addKey(key, state);
	}

	static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{
		if (reset)
			removeKeyboard();

		keyboardScheme = scheme;

		switch (scheme)
		{
			case Solo:
				bindKeys(Control.UI_UP, [W, FlxKey.UP]);
				bindKeys(Control.UI_DOWN, [S, FlxKey.DOWN]);
				bindKeys(Control.UI_LEFT, [A, FlxKey.LEFT]);
				bindKeys(Control.UI_RIGHT, [D, FlxKey.RIGHT]);
				bindKeys(Control.NOTE_UP, [W, FlxKey.UP]);
				bindKeys(Control.NOTE_DOWN, [S, FlxKey.DOWN]);
				bindKeys(Control.NOTE_LEFT, [A, FlxKey.LEFT]);
				bindKeys(Control.NOTE_RIGHT, [D, FlxKey.RIGHT]);
				bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
				bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				bindKeys(Control.RESET, [R]);
			case Duo(true):
				bindKeys(Control.UI_UP, [W]);
				bindKeys(Control.UI_DOWN, [S]);
				bindKeys(Control.UI_LEFT, [A]);
				bindKeys(Control.UI_RIGHT, [D]);
				bindKeys(Control.NOTE_UP, [W]);
				bindKeys(Control.NOTE_DOWN, [S]);
				bindKeys(Control.NOTE_LEFT, [A]);
				bindKeys(Control.NOTE_RIGHT, [D]);
				bindKeys(Control.ACCEPT, [G, Z]);
				bindKeys(Control.BACK, [H, X]);
				bindKeys(Control.PAUSE, [ONE]);
				bindKeys(Control.RESET, [R]);
			case Duo(false):
				bindKeys(Control.UI_UP, [FlxKey.UP]);
				bindKeys(Control.UI_DOWN, [FlxKey.DOWN]);
				bindKeys(Control.UI_LEFT, [FlxKey.LEFT]);
				bindKeys(Control.UI_RIGHT, [FlxKey.RIGHT]);
				bindKeys(Control.NOTE_UP, [FlxKey.UP]);
				bindKeys(Control.NOTE_DOWN, [FlxKey.DOWN]);
				bindKeys(Control.NOTE_LEFT, [FlxKey.LEFT]);
				bindKeys(Control.NOTE_RIGHT, [FlxKey.RIGHT]);
				bindKeys(Control.ACCEPT, [O]);
				bindKeys(Control.BACK, [P]);
				bindKeys(Control.PAUSE, [ENTER]);
				bindKeys(Control.RESET, [BACKSPACE]);
			case None | Custom: // nothing
		}
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addGamepadWithSaveData(id:Int, keys:Device)
	{
		gamepadsAdded.push(id);
		fromSaveData(keys, Device.Gamepad(id));
	}

	public function addDefaultGamepad(id):Void
	{
		addGamepadLiteral(id, [
			Control.ACCEPT => [A], Control.BACK => [B, FlxGamepadInputID.BACK], Control.UI_UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.UI_DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN], Control.UI_LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.UI_RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT], Control.NOTE_UP => [DPAD_UP, Y, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP],
			Control.NOTE_DOWN => [DPAD_DOWN, A, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN],
			Control.NOTE_LEFT => [DPAD_LEFT, X, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT],
			Control.NOTE_RIGHT => [DPAD_RIGHT, B, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT], Control.PAUSE => [START], Control.RESET => [Y]]);
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}
}
