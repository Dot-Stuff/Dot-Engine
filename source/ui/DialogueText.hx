package ui;

import ui.AtlasText.AtlasFont;

/**
 * Stole this from FlxTypeText
 */
class DialogueText extends ui.AtlasText
{
	public var completeCallback:Void->Void;

	public var delay:Float = 0.05;
    public var eraseDelay:Float = 0.02;
	public var paused:Bool = false;
	public var prefix:String = "";
	public var autoErase:Bool = false;
	public var waitTime:Float = 1.0;

	var finalText:String = "";
	var timer:Float = 0.0;
	var waitTimer:Float = 0.0;
	var _length:Int = 0;
	var typing:Bool = false;
    var typingVariation:Bool = false;
    var typeVarPercent:Float = 0.5;
    static var helperString:String = "";
	var erasing:Bool = false;
	var waiting:Bool = false;

	public function new(x:Float, y:Float, text:String, ?font:AtlasFont = Default)
	{
		super(x, y, text, font);
		finalText = text;
	}

    public override function update(elapsed:Float)
    {
        if (waiting && !paused)
        {
            waitTimer -= elapsed;

            if (waitTimer <= 0)
            {
                waiting = false;
                erasing = true;
            }
        }

        if (!waiting && !paused)
        {
            if (_length < finalText.length && typing)
            {
                timer += elapsed;
            }

            if (_length > 0 && erasing)
            {
                timer += elapsed;
            }
        }

        if (typing || erasing)
        {
            if (typing && timer >= delay)
            {
                _length += Std.int(timer / delay);
                if (_length > finalText.length)
                    _length = finalText.length;
            }

            if (erasing && timer >= eraseDelay)
            {
                _length -= Std.int(timer / eraseDelay);
                if (_length < 0)
                    _length = 0;
            }

            if ((typing && timer >= delay) || (erasing && timer >= eraseDelay))
            {
                if (typingVariation)
                {
                    if (typing)
                    {
                        timer = FlxG.random.float(-delay * typeVarPercent / 2, delay * typeVarPercent / 2);
                    }
                    else
                    {
                        timer = FlxG.random.float(-eraseDelay * typeVarPercent / 2, eraseDelay * typeVarPercent / 2);
                    }
                }
                else
                {
                    timer %= delay;
                }
            }
        }

        helperString = prefix + finalText.substr(0, _length);

        if (helperString != text)
        {
            text = helperString;

            if (_length >= finalText.length && typing && !waiting && !erasing)
                onComplete();

            if (_length == 0 && erasing && !typing && !waiting)
                onErased();
        }

        super.update(elapsed);
    }

	public function resetText(text:String):Void
	{
		this.text = "";
		finalText = text;
		typing = false;
		erasing = false;
		paused = false;
		waiting = false;
		_length = 0;
	}

	public function start(?Delay:Float):Void
	{
		if (Delay != null)
		{
			delay = Delay;
		}

		typing = true;
		erasing = false;
		paused = false;
		waiting = false;

		insertBreakLines();
	}

	function insertBreakLines()
	{
		var saveText = text;

		var last = finalText.length;

		while (true)
		{
			last = finalText.substr(0, last).lastIndexOf(" ");

			if (last <= 0)
				break;

			text = prefix + finalText;

			var nextText = finalText.substr(0, last) + "\n" + finalText.substr(last + 1, finalText.length);

			text = prefix + nextText;

            finalText = nextText;
		}

		text = saveText;
	}

	public function skip()
	{
		if (erasing || waiting)
		{
			_length = 0;
			waiting = false;
		}
		else if (typing)
		{
			_length = finalText.length;
		}
	}

    function onErased():Void
    {
        timer = 0;
        erasing = false;
    }

	function onComplete():Void
	{
		timer = 0;
		typing = false;

		if (completeCallback != null)
			completeCallback();

		if (autoErase && waitTime <= 0)
		{
			erasing = true;
		}
		else if (autoErase)
		{
			waitTimer = waitTime;
			waiting = true;
		}
	}
}
