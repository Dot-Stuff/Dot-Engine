package;

using StringTools;

class Boyfriend extends Character
{
	public var startedDeath:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		super(x, y, char, true);
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim.name.startsWith('sing'))
			holdTimer += elapsed;
		else
			holdTimer = 0;

		if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished)
			playAnim('idle', true, false, 10);

		if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
			playAnim('deathLoop');

		super.update(elapsed);
	}
}
