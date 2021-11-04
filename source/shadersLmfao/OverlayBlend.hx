package shadersLmfao;

import flixel.system.FlxAssets.FlxShader;

class OverlayBlend
{
    
}

class OverlayBlendShader extends FlxShader
{
    @:glFragmentSource('
        , 0.0) - gl_FragCoord.xy / openfl_TextureSize
    ')
    public function new()
    {
        super();
    }
}
