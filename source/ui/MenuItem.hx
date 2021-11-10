package ui;

import flixel.FlxSprite;

class MenuItem extends FlxSprite
{
    public var fireInstantly:Bool = false;
	public var selected(get, never):Bool;

    public var name:String;
    public var callback:Void->Void;

    public function new(x:Float, y:Float, name:String, callback:Void->Void):Void
    {
        super(x, y);

        antialiasing = true;
        setData(name, callback);
        idle();
    }

	function get_selected():Bool
	{
		return alpha == 1;
	}

	public function setData(name:String, callback:Void->Void):Void
	{
		this.name = name;

		if (callback != null)
            this.callback = callback;
	}

	public function setItem(name:String, callback:Void->Void):Void
	{
		setData(name, callback);
		selected ? select() : idle();
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
