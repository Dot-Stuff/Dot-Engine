package ui;

import flixel.graphics.frames.FlxFramesCollection;
import flixel.FlxSprite;

class MenuTypedList extends FlxSprite
{

}

class AtlasMenuList extends FlxSprite
{
    
}

class MenuItem extends FlxSprite
{

}

class AtlasMenuItem extends FlxSprite
{
	var atlas:FlxFramesCollection;

    public function new()
    {
        super();

        atlas = Paths.getSparrowAtlas('main_menu');
    }

	function setData(name:String)
	{
		frames = atlas;
		animation.addByPrefix("idle", '$name idle', 24);
		animation.addByPrefix("selected", '$name selected', 24);
	}

	function changeAnim(name:String)
	{
		animation.play(name);
		updateHitbox();
	}

	function idle()
	{
		changeAnim("idle");
	}

    function select()
    {
        changeAnim("selected");
    }

    function get_selected()
    {
        return null != animation.curAnim ? "selected" == animation.curAnim.name : false;
    }

    public override function destroy()
    {
        super.destroy();

        atlas = null;
    }
}
