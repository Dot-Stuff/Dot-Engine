package ui;

import flixel.FlxSprite;

class CheckboxThingie extends FlxSprite
{
    public var daValue(default, set):Bool = false;

    public function new(x:Float, y:Float, checked:Bool)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('checkboxThingie');

        animation.addByPrefix('static', 'Check Box unselected', 24, false);
        animation.addByPrefix('checked', 'Check Box selecting animation', 24, false);

        antialiasing = true;

        setGraphicSize(Std.int(width * 0.7));
        updateHitbox();

        daValue = checked;
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        switch (animation.curAnim.name)
        {
            case 'checked':
                offset.set(17, 70);
            case 'static':
                offset.set();
        }
    }

    @:noCompletion
    function set_daValue(daValue:Bool):Bool
    {
        if (daValue)
            animation.play('checked', true);
        else
            animation.play('static');

        return daValue;
    }
}