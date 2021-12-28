package;

import flixel.ui.FlxVirtualPad;

class MobilePad extends FlxVirtualPad
{
    public var DPad:FlxDPadMode;
    public var Action:FlxActionMode;

    public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode)
    {
        super(DPad, Action);
        alpha = 0.6;

        this.DPad = DPad;
        this.Action = Action;
    }
}

/*class Hitbox {
    
}*/