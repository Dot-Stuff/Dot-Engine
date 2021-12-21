package mods;

import openfl.Assets;

class ModTest implements IHook
{
	public function new()
	{
		buildPlayStateHooks();
	}

	public var onUpdate:Void->Void = function() return;
    public var onKillCombo:Void->Void = function() return;

	@:hscript({
		context: [setScoreTxt],
		pathName: "initTest"
	})
	function buildPlayStateHooks():Void
	{
		if (script_variables.get('onUpdate') != null)
		{
			onUpdate = script_variables.get('onUpdate');
		}
		if (script_variables.get('onKillCombo') != null)
		{
			onKillCombo = script_variables.get('onKillCombo');
		}
	}

	public function setScoreTxt(value:String):String
	{
		PlayState.scoreTxt.text += value;
		return PlayState.scoreTxt.text;
	}
}
