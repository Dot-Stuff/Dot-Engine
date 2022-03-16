package;

import flixel.FlxState;

class InitState extends FlxState
{
    public override function create():Void
    {
        FlxG.save.bind('funkin', 'ninjamuffin99');
		/*@:privateAccess
		FlxG.sound.loadSavedPrefs();*/

        mods.LocaleHandler.init();

        #if MODDING
		mods.ModHandler.init();
		#end

        FlxG.switchState(new TitleState());
    }
}
