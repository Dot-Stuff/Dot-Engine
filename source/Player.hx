package;

using StringTools;

class Player extends Character
{
    public var isBot:Bool = false;
    public var startedDeath:Bool = false;
    public var settings:PlayerSettings;

    public function new(x:Float, y:Float, ?char:String = "bf", ?isPlayer:Bool = false, ?isBot:Bool = false)
    {
        this.isBot = isBot;

        super(x, y, char, isPlayer);
    }

    override function update(elapsed:Float)
    {
        if (!isBot)
        {
            if (animation.curAnim.name.startsWith('sing'))
                holdTimer += elapsed;
            else
                holdTimer = 0;
        }

        if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished)
            playAnim('idle', true, false, 10);

        if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
            playAnim('deathLoop');

        super.update(elapsed);
    }
}