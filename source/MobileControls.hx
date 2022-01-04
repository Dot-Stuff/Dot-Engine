package;

import flixel.input.FlxInput.FlxInputState;
import flixel.ui.FlxButton;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalIFlxInput;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInput;
import Controls.Control;

enum MobileControl
{
	DEFAULT;
	RIGHT;
	LEFT;
	HITBOX;
}

class MobileControls extends Controls
{
	public function setVirtualPad(virtualPad:MobilePad)
	{
		switch (virtualPad.dPadMode)
		{
			case UP_DOWN:
				inline forEachBound(Control.UI_UP, (action, state) -> addButton(action, virtualPad.buttonUp, state));
				inline forEachBound(Control.UI_DOWN, (action, state) -> addButton(action, virtualPad.buttonDown, state));
			case LEFT_RIGHT:
				inline forEachBound(Control.UI_LEFT, (action, state) -> addButton(action, virtualPad.buttonLeft, state));
				inline forEachBound(Control.UI_RIGHT, (action, state) -> addButton(action, virtualPad.buttonRight, state));
			case UP_LEFT_RIGHT:
				inline forEachBound(Control.UI_UP, (action, state) -> addButton(action, virtualPad.buttonUp, state));
				inline forEachBound(Control.UI_LEFT, (action, state) -> addButton(action, virtualPad.buttonLeft, state));
				inline forEachBound(Control.UI_RIGHT, (action, state) -> addButton(action, virtualPad.buttonRight, state));
			case FULL:
				inline forEachBound(Control.UI_UP, (action, state) -> addButton(action, virtualPad.buttonUp, state));
				inline forEachBound(Control.UI_DOWN, (action, state) -> addButton(action, virtualPad.buttonDown, state));
				inline forEachBound(Control.UI_LEFT, (action, state) -> addButton(action, virtualPad.buttonLeft, state));
				inline forEachBound(Control.UI_RIGHT, (action, state) -> addButton(action, virtualPad.buttonRight, state));
			case NONE:
		}

		switch (virtualPad.actionMode)
		{
			case A:
				inline forEachBound(Control.ACCEPT, (action, state) -> addButton(action, virtualPad.buttonA, state));
			default:
				inline forEachBound(Control.ACCEPT, (action, state) -> addButton(action, virtualPad.buttonA, state));
				inline forEachBound(Control.BACK, (action, state) -> addButton(action, virtualPad.buttonB, state));
			case NONE:
		}
	}

	public var trackedinputs:Array<FlxActionInput> = [];

	public function addButton(action:FlxActionDigital, button:FlxButton, state:FlxInputState)
	{
		var input = new FlxActionInputDigitalIFlxInput(button, state);
		trackedinputs.push(input);

		action.add(input);
	}
}
