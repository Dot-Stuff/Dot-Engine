package ui;

import ui.MenuTypedList.TextMenuList;
import flixel.FlxObject;
import Controls.Device;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import ui.Prompt;
import Controls.Control;

using StringTools;

class ControlsMenu extends ui.OptionsState.Page
{
	inline static public var COLUMNS = 2;
	static var controlList = Control.createAll();

	static var controlGroups:Array<Array<Control>> = [
		[NOTE_UP, NOTE_DOWN, NOTE_LEFT, NOTE_RIGHT],
		[UI_UP, UI_DOWN, UI_LEFT, UI_RIGHT, ACCEPT, BACK]
	];

	var itemGroups:Array<Array<InputItem>> = [for (i in 0...controlGroups.length) []];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;

	var labels:FlxTypedGroup<AtlasText>;

	var controlGrid:MenuTypedList;

	var deviceList:TextMenuList;
	var deviceListSelected:Bool;
	var currentDevice:Device = Keys;

	var prompt:Prompt;

	public function new()
	{
		super();

		menuCamera = new FlxCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = 0;
		camera = menuCamera;

		labels = new FlxTypedGroup<AtlasText>();
		var atlasTexts = new FlxTypedGroup<AtlasText>();

		controlGrid = new MenuTypedList(Columns(2), Vertical);
		add(labels);
		add(atlasTexts);
		add(controlGrid);

		if (FlxG.gamepads.numActiveGamepads > 0)
		{
			var c:FlxSprite = new FlxSprite();
			c.makeGraphic(FlxG.width, 100, -328339);
			add(c);

			deviceList = new TextMenuList(Horizontal, None);
			add(deviceList);

			deviceListSelected = true;

			var keyboardItem = deviceList.createItem(0, 0, "Keyboard", Bold, function()
			{
				selectDevice(Keys);
			});

			keyboardItem.x = FlxG.width / 2 - keyboardItem.width - 30;
			keyboardItem.y = (c.height - keyboardItem.height) / 2;

			var gamepadItem = deviceList.createItem(0, 0, "Gamepad", Bold, function()
			{
				selectDevice(Device.Gamepad(FlxG.gamepads.firstActive.id));
			});

			gamepadItem.x = FlxG.width / 2 + 30;
			gamepadItem.y = (c.height - gamepadItem.height) / 2;
		}

		var posForStuff = deviceList == null ? 30 : 120;
		var curName:String = null;

		for (i in controlList)
		{
			var l:String = i.getName();
			var atlasText;

			if (curName != 'UI_' && l.indexOf("UI_") == 0)
			{
				curName = 'UI_';

				atlasText = new AtlasText(0, posForStuff, "UI", Bold);
				atlasTexts.add(atlasText).screenCenter(X);
				posForStuff += 70;
			}
			else if (curName != "NOTE_" && l.indexOf("NOTE_") == 0)
			{
				curName = "NOTE_";

				atlasText = new AtlasText(0, posForStuff, "NOTES", Bold);
				atlasTexts.add(atlasText).screenCenter(X);
				posForStuff += 70;
			}

			if (curName != null && l.indexOf(curName) == 0)
				l = l.substr(curName.length);

			var textLabel = labels.add(new AtlasText(150, posForStuff, l, Bold));
			textLabel.alpha = 0.6;

			createItem(textLabel.x + 400, posForStuff, i, 0);
			createItem(textLabel.x + 400 + 300, posForStuff, i, 1);
			posForStuff += 70;
		}

		camFollow = new FlxObject(FlxG.width / 2, 0, 70, 70);

		if (deviceList != null)
		{
			camFollow.y = deviceList.members[deviceList.selectedIndex].y;
			deviceList.members[deviceList.selectedIndex].idle();
			controlGrid.enabled = false;
		}
		else
			camFollow.y = controlGrid.members[controlGrid.selectedIndex].y;

		menuCamera.follow(camFollow, null, 0.06);
		menuCamera.deadzone.setPosition(0, 100);
		menuCamera.deadzone.setSize(menuCamera.width, menuCamera.height - 200);
		menuCamera.minScrollY = 0;

		controlGrid.onChange.add(function(listener:FlxSprite)
		{
			camFollow.y = listener.y;
			labels.forEach(function(label)
			{
				label.alpha = 0.6;
			});
			labels.members[Std.int(controlGrid.selectedIndex / 2)].alpha = 1;
		});

		prompt = new Prompt("\nPress any key to rebind\n\n\n    Escape to cancel", None);
		prompt.create();
		prompt.createBgFromMargin(300, -328339);
		prompt.back.scrollFactor.set(0, 0);
		prompt.exists = false;
		add(prompt);
	}

	public function createItem(x:Float, y:Float, control:Control, index:Int)
	{
		var inputItem = new InputItem(x, y, currentDevice, control, index, onSelect);

		for (i in 0...controlGroups.length)
		{
			if (controlGroups[i].indexOf(control) != -1)
				itemGroups[i].push(inputItem);
		}

		return controlGrid.addItem(inputItem.name, inputItem);
	}

	public function onSelect()
	{
		canExit = controlGrid.enabled = false;
		prompt.exists = true;
	}

	public function goToDeviceList()
	{
		controlGrid.members[controlGrid.selectedIndex].idle();
		labels.members[Std.int(controlGrid.selectedIndex / 2)].alpha = 0.6;
		controlGrid.enabled = false;
		canExit = deviceList.enabled = true;
		camFollow.y = deviceList.members[deviceList.selectedIndex].y;
		deviceListSelected = true;
	}

	public function selectDevice(selectedDevice:Device)
	{
		currentDevice = selectedDevice;

		for (i in 0...controlGrid.members.length)
		{
			var item:InputItem = cast controlGrid.members[i];
			item.updateDevice(currentDevice);
		}

		var b = selectedDevice == Keys ? 'Escape' : 'Back';
		if (selectedDevice == Keys)
			prompt.setText('\nPress any key to rebind\n\n\n\n		$b to cancel');
		else
			prompt.setText('\nPress any button\n   to rebind\n\n\n $b to cancel');

		controlGrid.members[controlGrid.selectedIndex].select();
		labels.members[Std.int(controlGrid.selectedIndex / 2)].alpha = 1;
		controlGrid.enabled = true;
		canExit = deviceListSelected = deviceList.enabled = false;
	}

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

		if (controlGrid.enabled
			&& deviceList != null
			&& !deviceListSelected
			&& controls.BACK)
			goToDeviceList();

        if (prompt.exists)
        {
            switch (currentDevice)
            {
                case Keys:
                    var what = FlxG.keys.firstJustReleased();
                    if (what != -1)
                    {
                        if (what != 27)
                            onInputSelect(what);

                        closePrompt();
                    }
                case Gamepad(id):
                    var what = FlxG.gamepads.getByID(id);
					var what2 = what.mapping.getID(what.firstJustReleasedRawID());

					if (what2 != -1)
					{
						if (what2 != 6)
							onInputSelect(what2);

						closePrompt();
					}
            }
        }
    }

    public function onInputSelect(input:Int)
    {
        var controlGridSelected:InputItem = cast controlGrid.members[controlGrid.selectedIndex];
        var flooredIndex = Math.floor(controlGrid.selectedIndex / 2) * 2;

		var idk:InputItem = cast controlGrid.members[flooredIndex];
		var idk2:InputItem = cast controlGrid.members[flooredIndex + 1];

        if (input != idk.input && input != idk2.input)
        {
            flooredIndex = 0;
            for (i in itemGroups)
            {
                if (i.indexOf(controlGridSelected) != -1)
                {
                    for (o in i)
                    {
                        if (controlGridSelected != o && input == o.input)
                        {
                            controls.replaceBinding(o.control, currentDevice, controlGridSelected.input, o.input);
                            o.input = controlGridSelected.input;
                            o.label.text = controlGridSelected.label.text;
                        }
                    }
                }
            }

            controls.replaceBinding(controlGridSelected.control, this.currentDevice, input, controlGridSelected.input);
            controlGridSelected.input = input;
            controlGridSelected.label.text = controlGridSelected.getLabel(input);
            PlayerSettings.player1.saveControls();
        }
    }

	public function closePrompt()
	{
		prompt.exists = false;
        controlGrid.enabled = false;

        if (deviceList == null)
            canExit = true;
	}

	public override function destroy()
	{
		super.destroy();

		itemGroups = null;

		if (FlxG.cameras.list.indexOf(menuCamera) != -1)
			FlxG.cameras.remove(menuCamera);
	}

	public override function set_enabled(val:Bool):Bool
	{
		if (!val)
		{
			controlGrid.enabled = false;

			if (deviceList != null)
				deviceList.enabled = false;
		}
		else
		{
			controlGrid.enabled = !deviceListSelected;

			if (deviceList != null)
				deviceList.enabled = deviceListSelected;
		}

		return super.set_enabled(val);
	}
}

class InputItem extends ui.MenuTypedList.TextMenuItem
{
	public var control:Control;
	var device:Device;

	public var input:Int = -1;
	var index:Int = -1;

	public function new(x:Float, y:Float, device:Device, control:Control, index:Int, newCallback:Void->Void):Void
	{
		this.device = device;
		this.control = control;
		this.index = index;
		this.input = getInput();

		super(x, y, getLabel(input), Default, newCallback);
	}

	public function updateDevice(device:Device)
	{
		if (this.device != null)
		{
			this.device = device;
			input = getInput();
			label.text = getLabel(input);
		}
	}

	function getInput():Int
	{
		var inputs = PlayerSettings.player1.controls.getInputsFor(control, device);

		if (index < inputs.length)
		{
			if (inputs[index] != 27 || inputs[index] != 6)
				return inputs[index];
			if (inputs.length > 2)
				return inputs[2];
		}

		return -1;
	}

	public function getLabel(id:Int):String
	{
		return id == -1 ? '---' : InputFormatter.format(id, device);
	}
}
