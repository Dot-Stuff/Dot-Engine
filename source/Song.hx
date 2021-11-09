package;

import Section.SwagSection;
import Section.SwagDialogue;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<Array<SwagSection>>;
	var dialogue:SwagDialogue;
	var bpm:Float;
	var needsVoices:Bool;
	var stageDefault:String;
	var speed:Array<Float>;

	var player1:String;
	var player2:String;
	var gf:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<Array<SwagSection>>;
	public var dialogue:SwagDialogue;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var stageDefault:String = 'stage';
	public var speed:Array<Float> = [1, 1, 1];

	public var gf:String = 'gf';
	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, notes, dialogue, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.dialogue = dialogue;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String):SwagSong
	{
		var rawJson = Assets.getText(Paths.json(jsonInput.toLowerCase())).trim();

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
