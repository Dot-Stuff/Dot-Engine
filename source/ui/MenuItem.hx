package ui;

import flixel.FlxSprite;

class MenuItem extends FlxSprite
{
    public var fireInstantly:Bool = false;

    var name:String;
    public var callback:Void->Void;

    public function new(x:Float, y:Float, newName:String, newCallback:Void->Void):Void
    {
        super(x, y);

        antialiasing = true;
        setData(newName, newCallback);
        idle();
    }

	public function get_selected():Bool
	{
		return alpha == 1;
	}

	public function setData(dataName:String, dataCallback:Void->Void):Void
	{
		name = dataName;

		if (dataCallback != null)
            callback = dataCallback;
	}

	public function setItem(itemName:String, itemCallback:Void->Void):Void
	{
		setData(itemName, itemCallback);
		get_selected() ? select() : idle();
	}

	public function idle():Void
	{
		alpha = 0.6;
	}

	public function select():Void
	{
		alpha = 1;
	}
}
