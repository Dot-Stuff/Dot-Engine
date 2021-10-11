package ui;

import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.ds.StringMap;
import flixel.FlxObject;
import flixel.FlxCamera;

class PreferencesMenu extends ui.OptionsState.Page
{
    public static var preferences:StringMap<Bool> = new StringMap<Bool>();
    public static var checkboxes:Array<CheckboxThingie> = [];

    var camFollow:FlxObject;
    var menuCamera:FlxCamera;
    static var items:TextMenuList;

    public function new()
    {
        super();

        menuCamera = new FlxCamera();
        FlxG.cameras.add(menuCamera, false);
        menuCamera.bgColor = 0;
        set_camera(this.menuCamera);

        items = new TextMenuList(0, 0);
        add(items);

        createPrefItem("naughtyness", "censor-naughty", true);
        createPrefItem("downscroll", "downscroll", false);
        createPrefItem("flashing menu", "flashing-menu", false);
        createPrefItem("Camera Zooming on Beat", "camera-zoom", false);
        createPrefItem("FPS Counter", "fps-counter", true);
        createPrefItem("Auto Pause", "auto-pause", false);

        camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);

        /*if (items != null)
            camFollow.y = items.members[items.selectedIndex].y;*/

        menuCamera.follow(camFollow, null, 0.06);
        menuCamera.minScrollY = 0;
        items.onChange.add(function()
        {
            
        });
    }

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
        preferenceCheck("fps-counter", true);
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
        var getPref = preferences.get(pref);
        getPref = !getPref;
        preferences.set(pref, getPref);
        checkboxes[items.selectedIndex].set_daValue(getPref);
        trace("toggled? " + Std.string(preferences.get(pref)));

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

        menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
        /*items.forEach(function(item:TextMenuList)
        {
            items.members[items.selectedIndex] == item ? item.x = 150 : item.x = 120;
        });*/
    }
}