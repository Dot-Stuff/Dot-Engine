package mods;

import openfl.Assets;
import flixel.text.FlxText;
import flixel.FlxSprite;
import polymod.hscript.HScriptable.HScriptParams;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;

class ModTest implements IHook
{
	var scoreTxt:FlxText;
	var healthBarBG:FlxSprite;
	var dad:Character;
	var bf:Character;
	var curSong:String;
	var camHUD:FlxCamera;

	public function new(scoreTxt:FlxText, healthBarBG:FlxSprite, dad:Character, bf:Character, curSong:String, camHUD:FlxCamera)
	{
		this.scoreTxt = scoreTxt;
		this.healthBarBG = healthBarBG;
		this.dad = dad;
		this.bf = bf;
		this.curSong = curSong;
		this.camHUD = camHUD;

		buildScriptHooks();
	}

	public var onCreate:Void->Void = function() return;
	public var onUpdate:Void->Void = function() return;
	public var onStepHit:Int->Void = function(curStep) return;
	public var onBeatHit:Void->Void = function() return;

    public var onKillCombo:Void->Void = function() return;
	public var onGoodNoteHit:Note->Void = function(note) return;
	public var onPopUpScore:String->Void = function(daRating) return;

	@:hscript({
		context: [FlxTween, scoreTxt, healthBarBG, dad, bf, curSong, camHUD],
		pathName: 'states/PlayState'
	})
	function buildScriptHooks():Void
	{
		if (script_variables.get('onCreate') != null)
			onCreate = script_variables.get('onCreate');

		// TODO: Add FixedUpdate and LateUpdate
		if (script_variables.get('onUpdate') != null)
			onUpdate = script_variables.get('onUpdate');

		if (script_variables.get('onStepHit') != null)
			onStepHit = script_variables.get('onStepHit');

		if (script_variables.get('onBeatHit') != null)
			onBeatHit = script_variables.get('onBeatHit');

		if (script_variables.get('onKillCombo') != null)
			onKillCombo = script_variables.get('onKillCombo');

		if (script_variables.get('onGoodNoteHit') != null)
			onGoodNoteHit = script_variables.get('onGoodNoteHit');

		if (script_variables.get('onPopUpScore') != null)
			onPopUpScore = script_variables.get('onPopUpScore');
	}
}
