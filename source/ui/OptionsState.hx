package ui;

import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * TODO: Clear saved data button.
 */
class OptionsState extends MusicBeatState
{
	/*function get_currentPage()
	{
		return pages.get(currentName);
	}*/

	public function new()
	{
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('menuDesat'));
		bg.color = FlxColor.PURPLE;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);

		/*a = addPage(ui.Options, new km(!1));
		var b = addPage(ui.Preferences, new ub),
			c = addPage(ui.Controls, new tf);
		if (a.hasMultipleOptions())
		{
			a.onExit.add(p(this, this.exitToMainMenu));
			var d = p(this, this.switchPage), e = ke.Options;
			c.onExit.add(function()
			{
				d(e)
			});
			var f = p(this, this.switchPage), h = ke.Options;
			b.onExit.add(function()
			{
				f(h)
			})
		}
		else
			c.onExit.add(p(this, this.exitToMainMenu)),
		this.setPage(ke.Controls);
		this.pages.get(this.currentName).set_enabled(!1);*/

		super();
	}

	/*function addPage(a, b)
	{
		b.onSwitch.add(p(this, switchPage));
		pages.set(a, b);
		add(b);
		b.set_exists(currentName == a);
	}

	function setPage(a)
	{
		pages.exists(currentName) && pages.get(currentName).set_exists(!1);
		currentName = a;
		pages.exists(currentName) && pages.get(currentName).set_exists(!0);

	}
	public override function finishTransOut()
	{
		super.finishTransOut();
		pages.get(this.currentName).set_enabled(!0);
	}

	function switchPage(a)
	{
		setPage(a)
	}

	function exitToMainMenu()
	{
		pages.get(currentName).set_enabled(!1);
		var a = new Qf;
		k.game._state.switchTo(a)
		&& (FlxG.game._requestedState = a)
	}*/
}

class Page extends FlxState
{

}
