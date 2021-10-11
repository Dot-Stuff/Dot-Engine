package ui;

import flixel.graphics.frames.FlxFramesCollection;
import flixel.FlxSprite;
import flixel.util.FlxSignal;

class MenuTypedList extends FlxSprite
{
    public var busy:Bool;
    public var onAcceptPress:FlxSignal;
    public var onChange:FlxSignal;
    public var selectedIndex:Int;

    public function new(x:Float, y:Float)
    {
        busy = false;
        //enable = true;
        onAcceptPress = new FlxSignal();
        onChange = new FlxSignal();
        selectedIndex = 0;

        super();
    }
}
