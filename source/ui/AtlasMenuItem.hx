package ui;

import flixel.graphics.frames.FlxFramesCollection;

class AtlasMenuItem extends ui.MenuItem
{
	var atlas:FlxFramesCollection;

	public function new(x:Float, y:Float, name:String, atlas:FlxFramesCollection, callback:Void->Void):Void
	{
		this.atlas = atlas;

		super(x, y, name, callback);
	}

	public override function setData(name:String, callback:Void->Void):Void
	{
		frames = atlas;
		animation.addByPrefix('idle', name + ' idle', 24);
		animation.addByPrefix('selected', name + ' selected', 24);

		super.setData(name, callback);
	}

	public function changeAnim(name:String):Void
	{
		animation.play(name);
		updateHitbox();
	}

	public override function idle():Void
	{
		changeAnim('idle');
	}

	public override function select():Void
	{
		changeAnim('selected');
	}

	public override function get_selected():Bool
	{
		return animation.curAnim != null ? animation.curAnim.name == 'selected' : false;
	}
}
