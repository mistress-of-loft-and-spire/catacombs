package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.DrawStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import haxe.ds.Vector;
import openfl.geom.Vector3D;

using flixel.util.FlxSpriteUtil;

class LineState extends FlxState
{
	
	var ent:Entity;
	
	var activeCamera:Camera;
	
	var ambient:Int = 0x000;
	var ambientIntensity:Float = 0.2;
	
	var canvas:FlxSprite;
	
	override public function create():Void
	{
		canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, 0x4d4867, true);
		
		activeCamera = new Camera(0, 0, -10);
		
		add(canvas);
	
		var lineStyle:LineStyle = { color: FlxColor.WHITE, thickness: 1 };
		var drawStyle:DrawStyle = { smoothing: false };
		
		canvas.drawCircle(20, 30, 20, FlxColor.GREEN);
		
		var vertices = new Array<FlxPoint>();
		vertices.push(new FlxPoint(40, 40));
		vertices.push(new FlxPoint(70, 40));
		vertices.push(new FlxPoint(70, 50));
		vertices.push(new FlxPoint(60, 50));
		vertices.push(new FlxPoint(60, 60));
		vertices.push(new FlxPoint(50, 60));
		vertices.push(new FlxPoint(50, 80));
		vertices.push(new FlxPoint(40, 80));
		
		for (i in 0...vertices.length)
		{
			for (j in 0...vertices.length)
			{
				canvas.drawLine(vertices[i].x*5, vertices[i].y*5, vertices[j].x*5, vertices[j].y*5, lineStyle, drawStyle);
			}
		}
		
		super.create();
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
