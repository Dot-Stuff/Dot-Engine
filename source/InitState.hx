package;

import flixel.FlxState;

class InitState extends FlxState
{
    public override function create():Void
    {
        #if MODDING
		mods.Modding.init();
		#end

        super.create();

        FlxG.switchState(new TitleState());
    }
}
