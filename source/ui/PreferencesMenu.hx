package ui;

import haxe.ds.StringMap;

class PreferencesMenu extends ui.OptionsState.Page
{
    public static var preferences:StringMap<Bool> = new StringMap<Bool>();
    public static var checkboxes:Array<Bool> = [];

    public static function getPref(name:String):Bool
    {
        return preferences.get(name);
    }

    public static function initPrefs()
    {
        preferenceCheck("censor-naughty", true);
        preferenceCheck("downscroll", false);
        preferenceCheck("flashing-menu", true);
        preferenceCheck("camera-zoom", true);
        preferenceCheck("fps-counter", false);
        preferenceCheck("auto-pause", true);

        if (getPref("fps-counter"))
            FlxG.stage.removeChild(Main.fpsCounter);

        FlxG.autoPause = getPref("auto-pause");
    }

    public static function preferenceCheck(name:String, defaultValue:Bool)
    {
        if (preferences.get(name) == null)
        {
            preferences.set(name, defaultValue);
            trace("set preference!");
        }
        else
        {
            trace("found preference: " + Std.string(preferences.get(name)));
        }
    }

    public function createPrefItem(name:String, pref:String, defaultVal:Bool)
    {
        

        trace('swag');
    }

    public function createCheckbox()
    {
        
    }

    public static function prefToggle(pref:String):Void
    {
        /*var getPref = preferences.get(pref);
        getPref = !getPref;
        preferences.set(pref, getPref);
        checkboxes[items.selectedIndex].set_daValue(getPref);
        trace("toggled? " + Std.string(preferences.get(pref)));*/

        switch (pref)
        {
            case 'auto-pause':
                FlxG.autoPause = PreferencesMenu.getPref("auto-pause");
            case 'fps-counter':
                if (PreferencesMenu.getPref("fps-counter"))
                    FlxG.stage.addChild(Main.fpsCounter);
                else
                    FlxG.stage.removeChild(Main.fpsCounter);
        }
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        /*menuCamera.set_followLerp(CoolUtil.camLerpShit(.05));
        items.forEach(function(item)
        {
            items.members[items.selectedIndex] == item ? item.x = 150 : item.x = 120;
        });*/
    }
}