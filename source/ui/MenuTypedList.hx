package ui;

import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import haxe.ds.StringMap;
import flixel.util.FlxSignal.FlxTypedSignal;
import ui.MenuItem;

class MenuTypedList<T:MenuItem> extends FlxTypedGroup<T>
{
	public var busy:Bool = false;
	public var byName:StringMap<Dynamic> = new StringMap<Dynamic>();
	public var wrapMode:WrapMode = WrapMode.Both;
	public var enabled:Bool = true;
	public var onAcceptPress:FlxTypedSignal<T->Void> = new FlxTypedSignal<T->Void>();
	public var onChange:FlxTypedSignal<T->Void> = new FlxTypedSignal<T->Void>();
	public var selectedIndex:Int = 0;
	public var navControls:NavControls = NavControls.Vertical;

	public function new(?navControl:NavControls = NavControls.Vertical, ?wrapMode:WrapMode)
	{
		if (wrapMode != null)
			this.wrapMode = wrapMode;
		else
		{
			var wrapConvert:WrapMode = WrapMode.Both;
			switch (navControl.getIndex())
			{
				case 0:
					wrapConvert = WrapMode.Horizontal;
				case 1:
					wrapConvert = WrapMode.Vertical;
				default:
					wrapConvert = WrapMode.Both;
			}

			wrapMode = wrapConvert;
		}

		super();
	}

	function addItem(name:String, menuItem:T):T
	{
		if (selectedIndex == length)
			menuItem.select();

		byName.set(name, menuItem);
		return add(menuItem);
	}

	public function resetItem(a:String, b:String, c:Void->Void)
	{
		var d = byName.get(a);

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

			var wrap:Bool = wrapMode.getIndex() == 2;

            var navIndex:Int = 0;
			var navShit:Int = navControls.getIndex();

			var leftP = controls.UI_LEFT_P;
			var rightP = controls.UI_RIGHT_P;
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;

			switch (navShit)
			{
				case 0:
					navIndex = navAxis(selectedIndex, length, leftP, rightP, wrap);
				case 1:
					navIndex = navAxis(selectedIndex, length, upP, downP, wrap);
				case 2:
					var leftUpP = controls.UI_LEFT_P || controls.UI_UP_P;
					var rightDownP = controls.UI_RIGHT_P || controls.UI_DOWN_P;
					navIndex = navAxis(selectedIndex, length, leftUpP, rightDownP, wrapMode.getIndex() != 3);
				case 3:
					navIndex = navGrid(navShit, leftP, rightP, wrap, upP, downP, wrap);
				case 4:
					navIndex = navGrid(navShit, upP, downP, wrap, leftP, rightP, wrap);
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

	function navGrid(a, b, c, d, e, f, h)
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
    var label:AtlasText;

    public function new(x:Float, y:Float, atlasText:AtlasText, newName:String, newCallback:Void->Void)
    {
        super(x, y, newName, newCallback);
        set_label(atlasText);
    }

    public function setEmptyBackground()
    {
        makeGraphic(1, 1, 0);
    }

    public function set_label(name:AtlasText)
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
            label.set_alpha(Alpha);
        }

        return super.set_alpha(Alpha);
    }

    public override function set_x(X:Float)
    {
        if (label != null)
        {
            label.set_x(X);
        }

        return super.set_x(X);
    }

    public override function set_y(Y:Float)
    {
        if (label != null)
        {
            label.set_y(Y);
        }

        return super.set_y(Y);
    }
}
