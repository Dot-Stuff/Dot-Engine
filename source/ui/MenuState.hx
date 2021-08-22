package ui;

import flixel.FlxObject;

enum MenuDirections
{
	NONE;
	UP;
	DOWN;
}

class MenuMetadata
{
	public var name:String = "";
	public var onAccept:Void->Void;

	public function new(name:String, onAccept:Void->Void)
	{
		this.name = name;
		this.onAccept = onAccept;
	}
}

class MenuState extends MusicBeatState
{
	private var curSelected:Int = 0;
	private var camFollow:FlxObject;

	private var items:Array<MenuMetadata> = [];

	private var selectedItem:Bool = false;

	public override function create()
	{
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		FlxG.camera.follow(camFollow, null, 0.06);

		super.create();
	}

	public override function update(elapsed:Float)
	{
		if (!selectedItem)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
	
				changeItem(UP);
			}
			else if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
	
				changeItem(DOWN);
			}
	
			if (controls.ACCEPT)
				acceptItem();
		}

		super.update(elapsed);
	}

	public function createItem(name:String, onAccept:Void->Void)
	{
		items.push(new MenuMetadata(name, onAccept));
	}

	public function changeItem(direction:MenuDirections)
	{
		if (direction.match(UP))
			curSelected--;
		else if (direction.match(DOWN))
			curSelected++;
	}

	public function acceptItem()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
	}
}

class MenuSubState extends MusicBeatSubstate
{
	private var curSelected:Int = 0;
	private var camFollow:FlxObject;

	private var items:Array<MenuMetadata> = [];

	private var selectedItem:Bool = false;

	public override function update(elapsed:Float)
	{
		if (!selectedItem)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
	
				changeItem(UP);
			}
			else if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
	
				changeItem(DOWN);
			}
	
			if (controls.ACCEPT)
				acceptItem();
		}

		super.update(elapsed);
	}

	public function createItem(name:String, onAccept:Void->Void)
	{
		items.push(new MenuMetadata(name, onAccept));
	}

	public function changeItem(direction:MenuDirections)
	{
		if (direction.match(UP))
			curSelected--;
		else if (direction.match(DOWN))
			curSelected++;
	}

	public function acceptItem()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
	}
}
