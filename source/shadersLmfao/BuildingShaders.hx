package shadersLmfao;

import flixel.system.FlxAssets.FlxShader;

class BuildingMover
{
    public var shader(default, null):BuildingShaders = new BuildingShaders();

    public function update(elapsed:Float):Void
    {
        shader.alphaShit.value[0] += elapsed;
    } 

    public function reset()
    {
        shader.alphaShit.value[0] = 0;
    }
}

class BuildingShaders extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float alphaShit;
        
        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
            if (color.a > 0.0)
                color -= alphaShit;
        
            gl_FragColor = color;
        }
    ')
	public function new()
	{
		super();
	}
}
