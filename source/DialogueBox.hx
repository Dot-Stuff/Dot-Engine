package;

import ui.AtlasText.AtlasFont;
import flixel.util.FlxColor;
import Section.DialogueSection;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

using StringTools;

// Wait just a moment. Why is this not a substate!!!??? W T F   AHHHHHHHHHHHHHHHHHHHHHHHHH
class DialogueBox extends MusicBeatSubstate
{
	var box:FlxSprite;

	var dialogue:DialogueText;
	var dialogueData:Array<DialogueSection> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bgFade:FlxSprite;

	var dialogueIndex:Int = 0;

	public function new()
	{
		super();

		dialogueData = PlayState.SONG.dialogue.data;

		FlxG.sound.playMusic(Paths.music(PlayState.SONG.dialogue.music), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.8);

		if (atSchool())
		{
			bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
			bgFade.scrollFactor.set();
			bgFade.alpha = 0;
			add(bgFade);

			new FlxTimer().start(0.83, function(tmr:FlxTimer)
			{
				bgFade.alpha += (1 / 5) * 0.7;
				if (bgFade.alpha > 0.7)
					bgFade.alpha = 0.7;
			}, 5);

			box = new FlxSprite(-20, 45);

			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0xFFD89494;

			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xFF3F2021;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}
		else
			box = new FlxSprite(40, FlxG.height * 0.5);

		// TODO: Unhardcode this please
		switch (PlayState.curStage)
		{
			case 'school':
				box.frames = Paths.getSparrowAtlas('dialogue/dialogueBox-pixel');
				box.animation.addByPrefix('intro', 'Normal Dialogue Intro', 24, false);
				box.animation.addByPrefix('complete', 'Normal Dialogue Complete', 24, true);
				box.animation.addByPrefix('confirm', 'Normal Dialogue Confirm', 24, false);

				box.animation.addByPrefix('intro-angry', 'Impact Dialogue Intro', 24, false);
				box.animation.addByPrefix('confirm-angry', 'Normal Dialogue Complete', 24, true);
			case 'school-evil':
				box.frames = Paths.getSparrowAtlas('dialogue/dialogueBox-evil');
				box.animation.addByPrefix('intro', 'Spirit Dialogue Intro', 24, false);
				box.animation.addByIndices('complete', 'Spirit Dialogue Complete', [0], "", 24, true);
				box.animation.addByIndices('confirm', 'Spirit Dialogue Confirm', [0], "", 24);

				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
			default:
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('intro', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('complete', 'speech bubble normal', 24, true);
				box.animation.addByPrefix('confirm', 'speech bubble normal', 24, true);

				box.animation.addByPrefix('intro-angry', 'speech bubble loud open', 24, false);
				box.animation.addByPrefix('complete-angry', 'speech bubble normal', 24, true);
				box.animation.addByPrefix('confirm-angry', 'AHH speech bubble', 24, true);
		}

		if (atSchool())
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('dialogue/${PlayState.SONG.player2}Portrait');
			portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = dialogueData[dialogueIndex].angry;

			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('dialogue/${PlayState.SONG.player1}Portrait');
			portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;

			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}
		else
			box.setGraphicSize(Std.int(box.width * 0.9));

		playAnim('intro');

		if (dialogueData[dialogueIndex].angry && atSchool())
			portraitLeft.animation.play('enter');

		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		if (atSchool())
		{
			portraitLeft.screenCenter(X);

			add(dropText);
			add(swagDialogue);
		}
		else
		{
			var shouldBeBold:AtlasFont = dialogueData[dialogueIndex].angry ? Bold : Default;
			dialogue = new DialogueText(100, 80 + (FlxG.height * 0.5), '', shouldBeBold);
			add(dialogue);
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		trace('our index: ' + dialogueIndex);

		if (atSchool())
			dropText.text = swagDialogue.text;

		dialogueOpened = box.animation.curAnim != null && box.animation.curAnim.name.startsWith('intro') && box.animation.curAnim.finished;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY)
		{
			playAnim('confirm');

			if (dialogueEnded)
			{
				if (atSchool())
					FlxG.sound.play(Paths.sound('clickText'), 0.8);

				if (dialogueData[dialogueIndex + 1] == null && dialogueData[dialogueIndex] != null)
				{
					if (!isEnding)
					{
						isEnding = true;

						FlxG.sound.music.fadeOut(2.2, 0);

						if (atSchool())
						{
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								box.alpha -= 1 / 5;
								bgFade.alpha -= 1 / 5 * 0.7;
								portraitLeft.visible = false;
								portraitRight.visible = false;
								swagDialogue.alpha -= 1 / 5;
								dropText.alpha = swagDialogue.alpha;
							}, 5);
						}

						new FlxTimer().start(1.2, function(tmr:FlxTimer)
						{
							finishThing();
							close();
						});
					}
				}
				else
				{
					dialogueIndex++;
					startDialogue();
				}
			}
			else if (dialogueStarted && atSchool())
				swagDialogue.skip();
		}

		super.update(elapsed);
	}

	var dialogueEnded:Bool = false;
	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		dialogueEnded = false;

		if (atSchool())
		{
			if (dialogueData[dialogueIndex].isPlayer1)
			{
				portraitRight.visible = false;
				if (!portraitLeft.visible && !dialogueData[dialogueIndex].angry)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			}
			else
			{
				portraitLeft.visible = dialogueData[dialogueIndex].angry;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			}
		}
		else
			box.flipX = dialogueData[dialogueIndex].isPlayer1;
	}

	function cleanDialog():Void
	{
		if (atSchool())
		{
			swagDialogue.resetText(dialogueData[dialogueIndex].line);
			swagDialogue.start(0.04);

			swagDialogue.completeCallback = function()
			{
				playAnim('complete');
				trace('dialogue finish');
	
				dialogueEnded = true;
			};
		}
		else
		{
			dialogue.text = dialogueData[dialogueIndex].line;

			// TODO: Finish the dialogue text
			playAnim('complete');
			trace('dialogue finish');

			/*var theDialog:AtlasText = new AtlasText(0, 70, dialogueData[dialogueIndex].line, Default);
			if (dialogueData[dialogueIndex].isPlayer1)
				theDialog.personTalking = PlayState.SONG.player1.toUpperCase();
			else
				theDialog.personTalking = PlayState.SONG.player2.toUpperCase();
			dialogue = theDialog;
			add(theDialog);*/
		}
	}

	function atSchool():Bool
	{
		// Simplify this later pls.
		return PlayState.curStage.toLowerCase().startsWith('school');
	}

	function playAnim(anim:String)
	{
		var angry:String = dialogueData[dialogueIndex].angry ? '-angry' : '';
		box.animation.play(anim + angry);
	}
}

/**
 * Type Text
 */
class DialogueText extends ui.AtlasText
{
	public var finalText(default, set):String = '';

	function set_finalText(value:String):String
	{
		return this.text;
	}
}
