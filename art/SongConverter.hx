#if !interp
// Needs this to be run by interp, just for me lol. :D
package;

#end

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

class SongConverter
{
	static function main()
    {
		/*Sys.stdout().writeString('Please type directory you want to convert: ');
		Sys.stdout().flush();
		final input = Sys.stdin().readLine();
		trace('Hello ${input}!');*/

		for (fileThing in FileSystem.readDirectory('./.'))
		{
			if (FileSystem.isDirectory(fileThing) && fileThing != 'songs' && fileThing != 'stages')
			{
				trace('Formatting $fileThing');
				formatSong(fileThing);
			}
		}
	}

	public static function formatSong(songName:String)
    {
		var existsArray:Array<Bool> = [];
		var songFiles:Array<String> = [
			'$songName/$songName-easy.json',
			'$songName/$songName.json',
			'$songName/$songName-hard.json'
		];

		existsArray.push(FileSystem.exists(songFiles[0]));
		existsArray.push(FileSystem.exists(songFiles[1]));
		existsArray.push(FileSystem.exists(songFiles[2]));

		// ALWAYS ASSUMES THAT 'songName.json' EXISTS AT LEAST!!!
		if (!existsArray[0])
			songFiles[0] = songFiles[1];
		if (!existsArray[2])
			songFiles[2] = songFiles[1];

		var fileNormal:Dynamic = cast Json.parse(File.getContent(songFiles[0]));
		var fileHard:Dynamic = cast Json.parse(File.getContent(songFiles[1]));
		var fileEasy:Dynamic = cast Json.parse(File.getContent(songFiles[2]));

		var daOgNotes:Dynamic = fileNormal.song.notes;
		var daOgSpeed:Float = fileNormal.song.speed;

		fileNormal.song.notes = [];
		fileNormal.song.speed = [];

		fileHard.song.notes = noteCleaner(fileHard.song.notes);
		daOgNotes = noteCleaner(daOgNotes);
		fileEasy.song.notes = noteCleaner(fileEasy.song.notes);

		fileNormal.song.notes.push(fileHard.song.notes);
		fileNormal.song.notes.push(daOgNotes);
		fileNormal.song.notes.push(fileEasy.song.notes);

		fileNormal.song.speed.push(fileHard.song.speed);
		fileNormal.song.speed.push(daOgSpeed);
		fileNormal.song.speed.push(fileEasy.song.speed);

		fileNormal.song.stageDefault = getStage(songName);
		fileNormal.song.gf = getGF(songName);
		fileNormal.song.bpm += '.0';

		if (!FileSystem.exists('songs'))
			FileSystem.createDirectory('songs');

		var daJson = Json.stringify(fileNormal);
		File.saveContent('songs/$songName.json', daJson);
	}

	static function noteCleaner(notes:Array<Dynamic>):Array<Dynamic>
	{
		var swagArray:Array<Dynamic> = [];
		for (i in notes)
		{
			if (i.sectionNotes.length > 0)
				swagArray.push(i);
		}

		return swagArray;
	}

	/*
	 * Quickly lil function just for me formatting the old songs hehehe
	 */
	static function getStage(songName:String):String
	{
		switch (songName)
		{
			case 'spookeez' | 'monster' | 'south':
				return "spooky";
			case 'pico' | 'blammed' | 'philly':
				return "philly";
			case 'milf' | 'satin-panties' | 'high':
				return "limo";
			case 'eggnog' | 'cocoa':
				return "mall";
			case 'winter-horrorland':
				return "mall-evil";
			case 'senpai' | 'roses':
				return "school";
			case 'thorns':
				return "school-evil";
			case 'ugh' | 'guns' | 'stress':
				return "tank";
		}

		return "stage";
	}

	static function getGF(songName:String):String
	{
		switch (songName)
		{
			case 'milf' | 'satin-panties' | 'high':
				return "gf-car";
			case 'eggnog' | 'cocoa' | 'winter-horrorland':
				return "gf-christmas";
			case 'senpai' | 'roses' | 'thorns':
				return "gf-pixel";
			case 'ugh' | 'guns':
				return "gf-tankmen";
			case 'stress':
				return "pico-speaker";
		}

		return "gf";
	}
}
