package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		#if desktop
		
		super();
		addChild(new FlxGame(640, 480, PlayState, 1, 60, 60, true));

		#elseif test
		
		FlxG.debugger.visible = true;
		#end
		
	}
}
