package ui;

import shadersLmfao.ColorSwap;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class ColorsMenu extends ui.OptionsState.Page
{
    var grpColors:FlxTypedGroup<NoteColor>;

    var curSelected:Int = 0;

    public function new()
    {
        super();

        grpColors = new FlxTypedGroup<NoteColor>();
        add(grpColors);

        for (i in 0...4)
        {
            var noteColor:NoteColor = new NoteColor(0, 0, i);
            noteColor.screenCenter(XY);
            noteColor.x += Note.swagWidth * Std.int(Math.abs(i));

            grpColors.add(noteColor);
        }

        changeSelection();
        changeColor();
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.UI_LEFT_P)
            changeSelection(-1);
        else if (controls.UI_RIGHT_P)
            changeSelection(1);

        if (controls.UI_UP)
			changeColor(-elapsed * 0.1);
		else if (controls.UI_DOWN)
			changeColor(elapsed * 0.1);
    }

    private function changeColor(change:Float = 1)
    {
        Note.arrowColors[curSelected] = change;
        grpColors.members[curSelected].updateColors();
    }

    private function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected >= grpColors.length)
			curSelected = 0;
		else if (curSelected < 0)
			curSelected = grpColors.length - 1;

		for (color in 0...grpColors.length)
		{
			if (color == curSelected)
				grpColors.members[color].alpha = 1;
			else
				grpColors.members[color].alpha = 0.5;
		}
    }
}

class NoteColor extends FlxSprite
{
    public var noteData:Int = 0;

    var noteColors:Array<String> = ["purple", "blue", "green", "red"];
	var colorSwap:ColorSwap;

    public function new(x:Float, y:Float, noteData:Int)
    {
        this.noteData = noteData;

        super(x, y);

        frames = Paths.getSparrowAtlas('NOTE_assets');

        animation.addByPrefix('greenScroll', 'green instance');
        animation.addByPrefix('redScroll', 'red instance');
        animation.addByPrefix('blueScroll', 'blue instance');
        animation.addByPrefix('purpleScroll', 'purple instance');

        setGraphicSize(Std.int(width * 0.7));
        updateHitbox();
        antialiasing = true;

        colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		updateColors();

        animation.play('${noteColors[noteData]}Scroll');
    }

    public function updateColors()
    {
        colorSwap.update(Note.arrowColors[noteData]);
    }
}