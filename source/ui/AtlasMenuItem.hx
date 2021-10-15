package ui;

import flixel.graphics.frames.FlxFramesCollection;

class AtlasMenuItem extends ui.MenuItem
{
	var atlas:FlxFramesCollection;

	public function new(x:Float, y:Float, newName:String, newAtlas:FlxFramesCollection, newCallback:Void->Void):Void
	{
		atlas = newAtlas;

		super(x, y, newName, newCallback);
	}

	public override function setData(newName:String, newCallback:Void->Void):Void
	{
		frames = atlas;
		animation.addByPrefix('idle', newName + ' idle', 24);
		animation.addByPrefix('selected', newName + ' selected', 24);

		super.setData(newName, newCallback);
	}

	public function changeAnim(animName:String):Void
	{
		animation.play(animName);
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

	public override function destroy():Void
	{
		super.destroy();
		atlas = null;
	}

	public override function get_selected():Bool
	{
		return animation.curAnim != null ? animation.curAnim.name == 'selected' : false;
	}
}
