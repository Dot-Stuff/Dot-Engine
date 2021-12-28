package;

import ui.PreferencesMenu;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import shadersLmfao.ColorSwap;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using StringTools;

class StaticNotes extends FlxTypedSpriteGroup<StaticNote>
{
    public function createItem(player:Int)
    {
        var item = new StaticNote(length, player);
        item.ID = length;

        return add(item);
    }
}

class StaticNote extends FlxSprite
{
    var noteData:Int;

    public function new(noteData:Int, player:Int)
    {
        this.noteData = noteData;

        super(Note.swagWidth * noteData);

        var colorSwap:ColorSwap = new ColorSwap();
        shader = colorSwap.shader;
        colorSwap.update(Note.arrowColors[noteData]);

        if (PlayState.curStage.startsWith('school'))
        {
            loadGraphic(Paths.image('pixelUI/arrows-pixels'), true, 17, 17);

            setGraphicSize(Std.int(width * PlayState.daPixelZoom));
            updateHitbox();
            antialiasing = false;

            switch (noteData)
            {
                case 0:
                    animation.add('static', [0]);
                    animation.add('pressed', [4, 8], 12, false);
                    animation.add('confirm', [12, 16], 24, false);
                case 1:
                    animation.add('static', [1]);
                    animation.add('pressed', [5, 9], 12, false);
                    animation.add('confirm', [13, 17], 24, false);
                case 2:
                    animation.add('static', [2]);
                    animation.add('pressed', [6, 10], 12, false);
                    animation.add('confirm', [14, 18], 12, false);
                case 3:
                    animation.add('static', [3]);
                    animation.add('pressed', [7, 11], 12, false);
                    animation.add('confirm', [15, 19], 24, false);
            }
        }
        else
        {
            frames = Paths.getSparrowAtlas('NOTE_assets');

            antialiasing = true;
            setGraphicSize(Std.int(width * 0.7));

            switch (noteData)
            {
                case 0:
                    animation.addByPrefix('static', 'arrow static instance 1');
                    animation.addByPrefix('pressed', 'left press', 24, false);
                    animation.addByPrefix('confirm', 'left confirm', 24, false);
                case 1:
                    animation.addByPrefix('static', 'arrow static instance 2');
                    animation.addByPrefix('pressed', 'down press', 24, false);
                    animation.addByPrefix('confirm', 'down confirm', 24, false);
                case 2:
                    animation.addByPrefix('static', 'arrow static instance 4');
                    animation.addByPrefix('pressed', 'up press', 24, false);
                    animation.addByPrefix('confirm', 'up confirm', 24, false);
                case 3:
                    animation.addByPrefix('static', 'arrow static instance 3');
                    animation.addByPrefix('pressed', 'right press', 24, false);
                    animation.addByPrefix('confirm', 'right confirm', 24, false);
            }
        }

        updateHitbox();
        scrollFactor.set();

        animation.play('static');

        if (!PreferencesMenu.getPref('middlescroll'))
            x += PlayState.notesX + ((FlxG.width / 2) * player);
    }

    public function tweenNote()
    {
        y -= 10;
        alpha = 0;
        FlxTween.tween(this, {y: y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * noteData)});
    }

    public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
    {
        animation.play(animName, force, reversed, frame);

        if (animName == 'confirm' && !PlayState.curStage.startsWith('school'))
        {
            centerOffsets();
            offset.x -= 13;
            offset.y -= 13;
        }
        else
            centerOffsets();
    }
}