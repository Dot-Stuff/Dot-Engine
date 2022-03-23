package;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
  * FPS class extension to display memory usage.
  * @author Kirill Poletaev
 */
class FPS_Mem extends TextField
{
	@:noCompletion private var times:Array<Float>;

	private var memPeak:Int = 0;

	public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		selectable = false;

		defaultTextFormat = new TextFormat("_sans", 12, color);

		text = "FPS: \nRAM: ";

        width = 250;

		times = [];

		addEventListener(Event.ENTER_FRAME, onEnter);
	}

	private function onEnter(_)
	{
		var now = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var mem:Int = Std.int(Math.round(System.totalMemory / 1024 / 1024 * 100) / 100);

		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "FPS: " + times.length;
            text += "\nRAM: " + mem + "mb / " + memPeak + "mb";
		}
	}
}
