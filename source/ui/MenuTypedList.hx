package ui;

import flixel.effects.FlxFlicker;
import flixel.util.FlxDestroyUtil;
import flixel.group.FlxGroup;
import haxe.ds.StringMap;
import flixel.FlxSprite;
import flixel.util.FlxSignal.FlxTypedSignal;

class MenuTypedList extends FlxTypedGroup<ui.MenuItem>
{
	public var busy:Bool = false;
	public var byName:StringMap<Dynamic> = new StringMap<Dynamic>(); // ?? This is not a string it's some class
	public var wrapMode:WrapMode = WrapMode.Both;
	public var enabled:Bool = true;
	public var onAcceptPress:FlxTypedSignal<FlxSprite->Void> = new FlxTypedSignal<FlxSprite->Void>();
	public var onChange:FlxTypedSignal<FlxSprite->Void> = new FlxTypedSignal<FlxSprite->Void>();
	public var selectedIndex:Int = 0;
	public var navControls:NavControls = NavControls.Vertical;

	public function new(?navControl:NavControls = NavControls.Vertical, ?wrapMode:WrapMode = null)
	{
		if (wrapMode != null)
			this.wrapMode = wrapMode;
		else
		{
			var wrapConvert:WrapMode = WrapMode.None;
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

	function addItem(name:String, menuItem:AtlasMenuItem)
	{
		if (selectedIndex == length)
			menuItem.select();

		byName.set(name, menuItem);
		return add(menuItem);
	}

	/*function resetItem(a, b, c)
		{
			if (!Object.prototype.hasOwnProperty.call(byName.h, a))
				throw Exception.thrown("No item named:" + a);

			var d = byName.get(a);
			var e = byName;

			if (Object.prototype.hasOwnProperty.call(byName.h, a))
				byName.get(a);

			byName.set(b, d);
			d.setItem(b, c);
			return d;
	}*/
	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (enabled && !busy)
		{
			var controls = PlayerSettings.player1.controls;

			var wrap:Bool = false;
			if (wrapMode.getIndex() == 2)
				wrap = true;

			var up = controls.UI_UP_P;
			var down = controls.UI_DOWN_P;
            var navIndex:Int = navAxis(selectedIndex, length, up, down, wrap);
			//var navShit:Int = navControls.getIndex();

			if (selectedIndex != navIndex)
			{
				FlxG.sound.play(Paths.sound("scrollMenu"));
				selectItem(navIndex);
			}

			if (controls.ACCEPT)
				accept();
		}
	}

	function navAxis(a, b, c, d, e)
	{
		if (c == d)
			return a;

		b += 1;
		a = b;

		return a;
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

	function has(field:String)
	{
		return Reflect.hasField(byName, field);
	}

	function getItem(item:String)
	{
		return byName.get(item);
	}

	public override function destroy()
	{
		super.destroy();

		/*FlxDestroyUtil.destroyArray(onChange.handlers);
		FlxDestroyUtil.destroyArray(onAcceptPress.handlers);*/
	}
}
