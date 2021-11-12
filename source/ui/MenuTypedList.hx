package ui;

import ui.AtlasText.AtlasFont;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import haxe.ds.StringMap;
import flixel.util.FlxSignal.FlxTypedSignal;
import ui.MenuItem;

enum NavControls
{
    Horizontal;
    Vertical;
    Both;
    Columns(num:Int);
    Rows(num:Int);
}

enum WrapMode
{
    Horizontal;
    Vertical;
    Both;
    None;
}

class MenuTypedList extends FlxTypedGroup<MenuItem>
{
	public var busy:Bool = false;
	public var byName:StringMap<MenuItem> = new StringMap<MenuItem>();
	public var wrapMode:WrapMode = WrapMode.Both;
	public var enabled:Bool = true;

	public var onAcceptPress:FlxTypedSignal<MenuItem->Void> = new FlxTypedSignal<MenuItem->Void>();
	public var onChange:FlxTypedSignal<MenuItem->Void> = new FlxTypedSignal<MenuItem->Void>();

	public var selectedIndex:Int = 0;
	public var navControls:NavControls = NavControls.Vertical;

	public function new(?navControls:NavControls = NavControls.Vertical, ?wrapMode:WrapMode)
	{
		this.navControls = navControls;

		if (wrapMode != null)
			this.wrapMode = wrapMode;
		else
			wrapMode = switch (navControls)
			{
				case Horizontal: WrapMode.Horizontal;
				case Vertical: WrapMode.Vertical;
				default: WrapMode.Both;
			}

		super();
	}

	public function addItem(name:String, menuItem:MenuItem):MenuItem
	{
		if (selectedIndex == length)
			menuItem.select();

		byName.set(name, menuItem);
		return add(menuItem);
	}

	public function resetItem(a:String, b:String, c:Void->Void)
	{
		if (!Reflect.hasField(byName.toString(), a))
			throw 'No item named: $a';

		var d = byName.get(a);

		if (Reflect.hasField(byName.toString(), a))
			byName.remove(a);

		byName.set(b, d);
		d.setItem(b, c);
		return d;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (enabled && !busy)
		{
			var controls = PlayerSettings.player1.controls;

			var wrap:Bool = wrapMode == Both;

            var navIndex:Int = 0;

			var leftP = controls.UI_LEFT_P;
			var rightP = controls.UI_RIGHT_P;
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;

			switch (navControls)
			{
				case Horizontal:
					navIndex = navAxis(selectedIndex, length, leftP, rightP, wrap);
				case Vertical:
					navIndex = navAxis(selectedIndex, length, upP, downP, wrap);
				case Both:
					navIndex = navAxis(selectedIndex, length, leftP || upP, rightP || downP, wrapMode != None);
				case Columns(num):
					navIndex = navGrid(num, leftP, rightP, wrap, upP, downP, wrap);
				case Rows(num):
					navIndex = navGrid(num, upP, downP, wrap, leftP, rightP, wrap);
			}

			if (selectedIndex != navIndex)
			{
				FlxG.sound.play(Paths.sound("scrollMenu"));
				selectItem(navIndex);
			}

			if (controls.ACCEPT)
				accept();
		}
	}

	function navAxis(change:Int, dir1:Int, direction1:Bool, direction2:Bool, wrap:Bool)
	{
		if (direction2 == direction1)
			return change;

		if (direction1)
		{
			if (change > 0)
				change--;
			else if (wrap)
				change = dir1 - 1;
		}
		else
		{
			if (dir1 - 1 > change)
				change++;
			else if (wrap)
				change = 0;
		}

		return change;
	}

	function navGrid(a:Int, b:Bool, c:Bool, d:Bool, e:Bool, f:Bool, h:Bool)
	{
		var m = Math.ceil(length / a);
		var n = Math.floor(selectedIndex / a);
		var k = selectedIndex % a;
		var kPoop = navAxis(k, a, b, c, d);
		var nPoop = navAxis(n, m, e, f, h);

		return Std.int(Math.min(length - 1, nPoop * a + kPoop));
	}

	function accept()
	{
		var index = members[selectedIndex];
		onAcceptPress.dispatch(index);

		if (index.fireInstantly)
			index.callback();
		else
		{
			busy = true;

			FlxG.sound.play(Paths.sound("confirmMenu"));
			FlxFlicker.flicker(index, 1, 0.06, true, false, function(c)
			{
				busy = false;
				index.callback();
			});
		}
	}

	function selectItem(change:Int)
	{
		members[selectedIndex].idle();
		selectedIndex = change;

		var index = members[selectedIndex];
		index.select();
		onChange.dispatch(index);
	}

	public function has(field:String)
	{
		return Reflect.hasField(byName, field);
	}

	public function getItem(item:String):MenuItem
	{
		return byName.get(item);
	}
}

class MenuTypedItem extends ui.MenuItem
{
    public var label(default, set):AtlasText;

    public function new(x:Float, y:Float, label:AtlasText, name:String, callback:Void->Void)
    {
        super(x, y, name, callback);
        this.label = label;
    }

    public function setEmptyBackground()
    {
		var orgWidth = width;
		var orgHeight = height;

        makeGraphic(1, 1, 0);
		width = orgWidth;
		height = orgHeight;
    }

	@:noCompletion
    function set_label(name:AtlasText)
    {
        if (name != null)
        {
            name.x = x;
            name.y = y;
            name.alpha = alpha;
        }

        return label = name;
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (label != null)
            label.update(elapsed);
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

    public override function set_alpha(Alpha:Float)
    {
        if (label != null)
        {
            label.alpha = Alpha;
        }

        return super.set_alpha(Alpha);
    }

    public override function set_x(X:Float)
    {
        if (label != null)
        {
            label.x = X;
        }

        return super.set_x(X);
    }

    public override function set_y(Y:Float)
    {
        if (label != null)
        {
            label.y = Y;
        }

        return super.set_y(Y);
    }
}

class TextMenuList extends MenuTypedList
{
    public function createItem(x:Float, y:Float, name:String, font:AtlasFont = Bold, callback:Void->Void, ?fireInstantly:Bool = false)
    {
        var menuItem = new TextMenuItem(x, y, name, font, callback);
        menuItem.fireInstantly = fireInstantly;

        return addItem(name, menuItem);
    }
}

class TextMenuItem extends TextTypedMenuItem
{
    public function new(x:Float, y:Float, name:String, font:AtlasFont = Bold, callback:Void->Void):Void
    {
        super(x, y, new AtlasText(0, 0, name, font), name, callback);

        setEmptyBackground();
    }
}

class TextTypedMenuItem extends MenuTypedItem
{
    public override function setItem(itemName:String, callback:Void->Void)
    {
        if (label != null)
        {
            label.text = itemName;
            label.alpha = alpha;
            width = label.width;
            height = label.height;
        }

        super.setItem(itemName, callback);
    }

    override function set_label(atlasName:AtlasText):AtlasText
    {
        super.set_label(atlasName);

        setItem(name, callback);

        return atlasName;
    }
}
