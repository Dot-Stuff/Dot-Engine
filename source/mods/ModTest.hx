package mods;

import openfl.Assets;
import flixel.text.FlxText;
import flixel.FlxSprite;

class ModTest implements IHook
{
	var scoreTxt:FlxText;
	var healthBarBG:FlxSprite;

	public function new(scoreTxt:FlxText, healthBarBG:FlxSprite)
	{
		this.scoreTxt = scoreTxt;
		this.healthBarBG = healthBarBG;

		buildPlayStateHooks();
	}

	public var onCreate:Void->Void = function() return;
	public var onUpdate:Void->Void = function() return;
    public var onKillCombo:Void->Void = function() return;
	public var onGoodNoteHit:Note->Void = function(note) return;
	public var onPopUpScore:String->Void = function(daRating) return;

	@:hscript({
		context: [scoreTxt, healthBarBG],
		pathName: "initTest"
	})
	function buildPlayStateHooks():Void
	{
		if (script_variables.get('onCreate') != null)
		{
			onCreate = script_variables.get('onCreate');
		}
		if (script_variables.get('onUpdate') != null)
		{
			onUpdate = script_variables.get('onUpdate');
		}
		if (script_variables.get('onKillCombo') != null)
		{
			onKillCombo = script_variables.get('onKillCombo');
		}
		if (script_variables.get('onGoodNoteHit') != null)
		{
			onGoodNoteHit = script_variables.get('onGoodNoteHit');
		}
		if (script_variables.get('onPopUpScore') != null)
		{
			onPopUpScore = script_variables.get('onPopUpScore');
		}
	}
}
