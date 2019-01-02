package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxClothSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.DrawStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import haxe.ds.Vector;
import openfl.geom.Vector3D;

using flixel.util.FlxSpriteUtil;

class FluxState extends FlxState
{
	
	var ent:Entity;
	
	var activeCamera:Camera;
	
	var ambient:Int = 0x000;
	var ambientIntensity:Float = 0.2;
	
	var test:Flux;
	
	override public function create():Void
	{
		//add(new Flux(0, 0));
		
		test = new Flux(30, 30, "assets/images/flag.png", 8, 8);
		test.setMesh(3, 3);
		
		add(test);
		
		super.create();
		
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.pressed)
		{
			test.meshVelocity.x = 10;
		}
		else
		{
			test.meshVelocity.x = 0;
			test.meshVelocity.y = 10;
		}
		
		
		super.update(elapsed);
	}
}
