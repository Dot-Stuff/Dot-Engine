package;

import flixel.util.FlxSort;
import flixel.FlxSprite;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var animationNotes:Array<Dynamic> = [];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				frames = Paths.getSparrowAtlas('characters/GF_assets');

				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				quickAnimAdd('scared', 'GF FEAR');

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-tankmen':
				frames = Paths.getSparrowAtlas('characters/gfTankmen');

				quickAnimAdd('sad', 'GF Crying at Gunpoint');
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile('gf');

				playAnim('danceRight');

			case 'gf-christmas':
				frames = Paths.getSparrowAtlas('characters/gfChristmas');

				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				quickAnimAdd('scared', 'GF FEAR');

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-car':
				frames = Paths.getSparrowAtlas('characters/gfCar');

				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);
				animation.addByIndices("idleHair", "GF Dancing Beat Hair blowing CAR", [10, 11, 12, 25, 26, 27], "", 24, true);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-pixel':
				frames = Paths.getSparrowAtlas('characters/gfPixel');

				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');

				quickAnimAdd('idle', 'Dad Idle Dance');
				quickAnimAdd('singUP', 'Dad Sing Note UP');
				quickAnimAdd('singRIGHT', 'Dad Sing Note LEFT');
				quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
				quickAnimAdd('singLEFT', 'Dad Sing Note RIGHT');

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'spooky':
				frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');

				quickAnimAdd('singUP', 'spooky UP NOTE');
				quickAnimAdd('singDOWN', 'spooky DOWN note');
				quickAnimAdd('singLEFT', 'note sing left');
				quickAnimAdd('singRIGHT', 'spooky sing right');
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'mom':
				frames = Paths.getSparrowAtlas('characters/Mom_Assets');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Sing Up");
				quickAnimAdd('singDOWN', "Mom Sing Down");
				quickAnimAdd('singLEFT', 'Mom Sing Left');
				quickAnimAdd('singRIGHT', 'Mom Sing Right');

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'mom-car':
				frames = Paths.getSparrowAtlas('characters/momCar');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Sing Up");
				quickAnimAdd('singDOWN', "Mom Sing Down");
				quickAnimAdd('singLEFT', 'Mom Sing Left');
				quickAnimAdd('singRIGHT', 'Mom Sing Right');
				animation.addByIndices("idleHair", "Mom Idle", [10, 11, 12, 13], "", 24, true);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');

				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas');

				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'pico':
				frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');

				quickAnimAdd('idle', "Pico Idle Dance");
				quickAnimAdd('singUP', 'pico Up note0');
				quickAnimAdd('singDOWN', 'Pico Down Note0');
				quickAnimAdd('singRIGHT', 'Pico NOTE LEFT0');
				quickAnimAdd('singLEFT', 'Pico Note Right0');
				quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
				quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');

				quickAnimAdd('singUPmiss', 'pico Up note miss');
				quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');
				quickAnimAdd('singDOWN-alt', 'Pico Down Shoot0');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'pico-speaker':
				frames = Paths.getSparrowAtlas('characters/picoSpeaker');

				quickAnimAdd('shoot1', 'Pico shoot 1');
				quickAnimAdd('shoot2', 'Pico shoot 2');
				quickAnimAdd('shoot3', 'Pico shoot 3');
				quickAnimAdd('shoot4', 'Pico shoot 4');

				loadOffsetFile(curCharacter);

				playAnim("shoot1");

				loadMappedAnims();

			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');

				quickAnimAdd('firstDeath', "BF dies");
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				quickAnimAdd('deathConfirm', "BF Dead confirm");

				quickAnimAdd('scared', 'BF idle shaking');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-holding-gf':
				frames = Paths.getSparrowAtlas('characters/bfAndGF');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				frames = Paths.getSparrowAtlas('characters/bfChristmas');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				frames = Paths.getSparrowAtlas('characters/bfCar');

				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				animation.addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], "", 24, true);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');

				quickAnimAdd('idle', 'BF IDLE');
				quickAnimAdd('singUP', 'BF UP NOTE');
				quickAnimAdd('singLEFT', 'BF LEFT NOTE');
				quickAnimAdd('singRIGHT', 'BF RIGHT NOTE');
				quickAnimAdd('singDOWN', 'BF DOWN NOTE');
				quickAnimAdd('singUPmiss', 'BF UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF DOWN MISS');

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');

				quickAnimAdd('singUP', "BF Dies pixel");
				quickAnimAdd('firstDeath', "BF Dies pixel");
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				quickAnimAdd('deathConfirm', "RETRY CONFIRM");
				animation.play('firstDeath');

				loadOffsetFile(curCharacter);

				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');

				quickAnimAdd('singUP', "BF Dead with GF Loop");
				quickAnimAdd('firstDeath', "BF Dies with GF");
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				quickAnimAdd('deathConfirm', "RETRY confirm holding gf");

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');

				quickAnimAdd('idle', 'Senpai Idle');
				quickAnimAdd('singUP', 'SENPAI UP NOTE');
				quickAnimAdd('singLEFT', 'SENPAI LEFT NOTE');
				quickAnimAdd('singRIGHT', 'SENPAI RIGHT NOTE');
				quickAnimAdd('singDOWN', 'SENPAI DOWN NOTE');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');

				quickAnimAdd('idle', 'Angry Senpai Idle');
				quickAnimAdd('singUP', 'Angry Senpai UP NOTE');
				quickAnimAdd('singLEFT', 'Angry Senpai LEFT NOTE');
				quickAnimAdd('singRIGHT', 'Angry Senpai RIGHT NOTE');
				quickAnimAdd('singDOWN', 'Angry Senpai DOWN NOTE');

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');

				quickAnimAdd('idle', "idle spirit_");
				quickAnimAdd('singUP', "up_");
				quickAnimAdd('singRIGHT', "right_");
				quickAnimAdd('singLEFT', "left_");
				quickAnimAdd('singDOWN', "spirit down_");

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');

				quickAnimAdd('idle', 'Parent Christmas Idle');
				quickAnimAdd('singUP', 'Parent Up Note Dad');
				quickAnimAdd('singDOWN', 'Parent Down Note Dad');
				quickAnimAdd('singLEFT', 'Parent Left Note Dad');
				quickAnimAdd('singRIGHT', 'Parent Right Note Dad');

				quickAnimAdd('singUP-alt', 'Parent Up Note Mom');
				quickAnimAdd('singDOWN-alt', 'Parent Down Note Mom');
				quickAnimAdd('singLEFT-alt', 'Parent Left Note Mom');
				quickAnimAdd('singRIGHT-alt', 'Parent Right Note Mom');

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'tankman':
				frames = Paths.getSparrowAtlas('characters/tankmanCaptain');

				quickAnimAdd('idle', "Tankman Idle Dance");
				quickAnimAdd('singUP', 'Tankman UP note 0');
				quickAnimAdd('singDOWN', 'Tankman DOWN note 0');
				quickAnimAdd('singRIGHT', 'Tankman Note Left 0');
				quickAnimAdd('singLEFT', 'Tankman Right Note 0');
				quickAnimAdd('singRIGHTmiss', 'Tankman Note Left MISS');
				quickAnimAdd('singLEFTmiss', 'Tankman Right Note MISS');

				quickAnimAdd('singUPmiss', 'Tankman UP note MISS');
				quickAnimAdd('singDOWNmiss', 'Tankman DOWN note MISS');
				quickAnimAdd('singDOWN-alt', 'PRETTY GOOD'); // PRETTY GOOD
				quickAnimAdd('singUP-alt', 'TANKMAN UGH'); // UGHHHHHHHH

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			default:
				// You can easyly place something lik trickman
				frames = Paths.getSparrowAtlas('characters/$curCharacter');

				quickAnimAdd('idle', "Idle");
				quickAnimAdd('singUP', 'Sing Up');
				quickAnimAdd('singDOWN', 'Sing Down');
				quickAnimAdd('singLEFT', 'Sing Left');
				quickAnimAdd('singRIGHT', 'Sing Right');

				loadOffsetFile(curCharacter);

				playAnim('idle');
		}

		dance();
		animation.finish();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				var left = animation.getByName('singLEFT');
				var right = animation.getByName('singRIGHT');
				var oldRight = right.frames;

				right.frames = left.frames;
				left.frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var leftMiss = animation.getByName('singLEFTmiss');
					var rightMiss = animation.getByName('singRIGHTmiss');
					var oldMiss = rightMiss.frames;

					rightMiss.frames = leftMiss.frames;
					leftMiss.frames = oldMiss;
				}
			}
		}
	}

	public function loadMappedAnims()
	{
		var swagShit = Song.loadFromJson('pico-speaker');

		var notes = swagShit.notes[PlayState.storyDifficulty];

		for (section in notes)
		{
			for (idk in section.sectionNotes)
			{
				animationNotes.push(idk);
			}
		}

		TankmenBG.animationNotes = animationNotes;

		trace(animationNotes);
		animationNotes.sort(sortAnims);
	}

	function sortAnims(val1:Array<Dynamic>, val2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, val1[0], val2[0]);
	}

	public function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}

	public function hasRightAndLeft():Bool
	{
		return animOffsets.exists('danceRight') && animOffsets.exists('danceLeft');
	}

	private function loadOffsetFile(offsetCharacter:String)
	{
		var daFile:Array<String> = CoolUtil.coolTextFile(Paths.file('images/characters/${offsetCharacter}Offsets.txt', TEXT));

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(" ");
			addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = curCharacter == 'dad' ? 6.1 : 4;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		if (curCharacter.endsWith('-car'))
		{
			// Looping hair anims after idle finished
			if (!animation.curAnim.name.startsWith('sing') && animation.curAnim.finished)
				playAnim('idleHair');
		}

		if (curCharacter == 'gf' && animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
			playAnim('danceRight');
		else if (curCharacter == 'pico-speaker')
		{
			// for pico??
			if (animationNotes.length > 0)
			{
				if (Conductor.songPosition > animationNotes[0][0])
				{
					trace('played shoot anim' + animationNotes[0][1]);

					var shootAnim:Int = 1;

					if (animationNotes[0][1] >= 2)
						shootAnim = 3;

					shootAnim += FlxG.random.int(0, 1);

					playAnim('shoot$shootAnim', true);
					animationNotes.shift();
				}
			}

			if (animation.curAnim.finished)
			{
				playAnim(animation.curAnim.name, false, false, animation.curAnim.numFrames - 3);
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;
	public var debugMode:Bool = false;

	public function dance()
	{
		if (debugMode)
			return;

		switch (curCharacter)
		{
			case 'tankman':
				if (!animation.curAnim.name.endsWith('DOWN-alt'))
					playAnim('idle');
			default:
				if (hasRightAndLeft())
				{
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						playAnim(danced ? 'danceRight' : 'danceLeft');
					}
				}
				else if (animOffsets.exists('idle'))
					playAnim('idle');
		}
	}

	public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
	{
		animation.play(animName, force, reversed, frame);

		var daOffset = animOffsets[animName];
		if (daOffset != null)
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (animName == 'singLEFT')
			{
				danced = true;
			}
			else if (animName == 'singRIGHT')
			{
				danced = false;
			}

			if (animName == 'singUP' || animName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
