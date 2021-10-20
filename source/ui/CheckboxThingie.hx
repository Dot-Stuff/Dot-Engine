package ui;

import flixel.FlxSprite;

class CheckboxThingie extends FlxSprite
{
    public var daValue:Bool = false;

    public function new(x:Float, y:Float, checked:Bool)
    {
        super();

        frames = Paths.getSparrowAtlas('checkboxThingie');

        animation.addByPrefix('static', 'Check Box unselected', 24, false);
        animation.addByPrefix('checked', 'Check Box selecting animation', 24, false);

        antialiasing = true;

        setGraphicSize(Std.int(width * 0.7));
        updateHitbox();

        set_daValue(checked);
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (animation.curAnim.name == 'checked')
            offset.set(17, 70);
        else if (animation.curAnim.name == 'static')
            offset.set();
    }

    public function set_daValue(checked:Bool):Bool
    {
        checked ? animation.play('checked', true) : animation.play('static');
        return checked;
    }
}