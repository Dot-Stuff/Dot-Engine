package ui;

import polymod.Polymod.ModMetadata;
import mods.Modding;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class ModdingSubstate extends ui.OptionsState.Page
{
	var grpMods:ModMenuList;

	public function new():Void
	{
		super();

		grpMods = new ModMenuList();
		add(grpMods);

		initModLists();
	}

	/*public override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.I && curSelected != 0)
		{
			var oldOne = grpMods.members[curSelected - 1];
			grpMods.members[curSelected - 1] = grpMods.members[curSelected];
			grpMods.members[curSelected] = oldOne;
			selections(-1);
		}

		if (FlxG.keys.justPressed.K && curSelected < grpMods.members.length - 1)
		{
			var oldOne = grpMods.members[curSelected + 1];
			grpMods.members[curSelected + 1] = grpMods.members[curSelected];
			grpMods.members[curSelected] = oldOne;
			selections(1);
		}

		super.update(elapsed);
	}

	function selections(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected >= modFolders.length)
			curSelected = 0;
		else if (curSelected < 0)
			curSelected = modFolders.length - 1;

		for (txt in 0...grpMods.length)
			grpMods.members[txt].unloaded = txt == curSelected;

		organizeByY();
	}*/

	function initModLists():Void
	{
		var modDatas = Modding.getAllMods().filter(function(m)
		{
			return m != null;
		});
		var loadedModIds = Modding.getConfiguredMods();

		var loadedMods:Array<ModMetadata> = [];
		var unloadedMods:Array<ModMetadata> = [];

		if (loadedModIds != null)
		{
			loadedMods = modDatas.filter(function(m)
			{
				return loadedModIds.contains(m.id);
			});
			unloadedMods = modDatas.filter(function(m)
			{
				return !loadedModIds.contains(m.id);
			});
		}
		else
		{
			unloadedMods = [];
			loadedMods = modDatas;
		}

		var loopNum:Int = 0;

		for (i in loadedMods)
		{
			grpMods.createItem(i, 0, 10 + (40 * loopNum), true);

			loopNum++;
		}

		for (i in unloadedMods)
		{
			grpMods.createItem(i, 0, 10 + (40 * loopNum));

			loopNum++;
		}
	}

	public function writeModPreferences()
	{
		var loadedModIds:Array<String> = grpMods.listCurrentMods().map(function(mod:ModMetadata) return mod.id);

		FlxG.save.data.modConfig = loadedModIds.join('~');
		FlxG.save.flush();
	}

	function organizeByY():Void
	{
		for (i in 0...grpMods.length)
		{
			grpMods.members[i].y = 10 + (40 * i);
		}
	}
}

class ModMenuList extends MenuTypedList
{
	public function createItem(modMetadata:ModMetadata, x:Null<Float>, y:Null<Float>, ?modEnabled:Bool)
	{
		var menuItem = new ModMenuItem(modMetadata, x, y);
		menuItem.fireInstantly = true;
		menuItem.modEnabled = modEnabled;
		menuItem.ID = length;

		return addItem(menuItem.name, menuItem);
	}

	public function listCurrentMods()
	{
		return members.map(function(a)
		{
			if (Std.isOfType(a, ModMenuItem))
			{
				var modA:ModMenuItem = cast a;

				if (modA.modEnabled)
					return modA.modMetadata;
			}
			return null;
		}).filter(function(b)
		{
			return b != null;
		});
	}
}

class ModMenuItem extends MenuItem
{
	public var modEnabled(default, set):Bool = false;
	public var modMetadata:ModMetadata;

	var label:FlxText;

	public function new(modMetadata:ModMetadata, x:Float, y:Float)
	{
		this.modMetadata = modMetadata;

		label = new FlxText(x, y, 0, modMetadata.title, 32);

		super(x, y, modMetadata.title, modCallback);

		if (modMetadata.icon != null)
			loadIcon(modMetadata.icon);

		label.x += width + 10;
	}

    public function loadIcon(bytes:haxe.io.Bytes)
    {
		var future = openfl.utils.ByteArray.loadFromBytes(bytes);

		future.onComplete(function(openFlBytes:openfl.utils.ByteArray)
		{
			var iconSize:Int = Std.int(label.height);
			var bitmapData = openfl.display.BitmapData.fromBytes(openFlBytes);

			loadGraphic(bitmapData);
			setGraphicSize(iconSize, iconSize);
			antialiasing = true;
			updateHitbox();
		});
    }

	function modCallback()
	{
		modEnabled = !modEnabled;
	}

	function set_modEnabled(value:Bool):Bool
	{
		modEnabled = value;

		if (modEnabled)
		{
			color = FlxColor.YELLOW;

			if (label != null)
				label.color = FlxColor.YELLOW;
		}
		else
		{
			color = FlxColor.WHITE;

			if (label != null)
				label.color = FlxColor.WHITE;
		}

		return modEnabled;
	}

	public override function draw()
	{
		super.draw();

		if (label != null)
		{
			label.cameras = cameras;
			label.scrollFactor.x = scrollFactor.x;
			label.scrollFactor.y = scrollFactor.y;
			scrollFactor.putWeak();
			label.draw();
		}
	}

	public override function idle():Void
	{
		alpha = 0.6;

		if (label != null)
			label.alpha = 0.6;
	}

	public override function select():Void
	{
		alpha = 1;

		if (label != null)
			label.alpha = 1;
	}
}
