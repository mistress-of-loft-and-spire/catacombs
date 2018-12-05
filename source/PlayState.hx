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

class PlayState extends FlxState
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
		
		ent = new Entity(0, 0, 0);
		add(ent);
		
		activeCamera = new Camera(0, 0, -10);
		
		add(canvas);
	
		var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 1 };
		var drawStyle:DrawStyle = { smoothing: false };
		
		canvas.drawCircle(20, 30, 20, FlxColor.GREEN);
		
		var vertices = new Array<FlxPoint>();
		vertices[0] = new FlxPoint(0, 0);
		vertices[1] = new FlxPoint(100, 0);
		vertices[2] = new FlxPoint(100, 300);
		vertices[3] = new FlxPoint(0, 100);
		canvas.drawPolygon(vertices, FlxColor.PURPLE);

		super.create();
		
	}

	override public function update(elapsed:Float):Void
	{
		var newC:Vector3D = new Vector3D();
		var newB:Vector3D = new Vector3D();
		var newA:Vector3D = new Vector3D();
		
		if (FlxG.keys.anyPressed([W])) activeCamera.z += 0.5;
		if (FlxG.keys.anyPressed([S])) activeCamera.z -= 0.5;
		
		if (FlxG.keys.anyPressed([A])) activeCamera.x += 0.5;
		if (FlxG.keys.anyPressed([D])) activeCamera.x -= 0.5;
		
		if (FlxG.keys.anyPressed([Q])) activeCamera.y += 0.5;
		if (FlxG.keys.anyPressed([E])) activeCamera.y -= 0.5;
		
		
		// - - - - gogo render
		
		//clear canvas
		canvas.fill(0x4d4867);
		
		for (i in ent.mesh.data)
		{
			
			newA.copyFrom(i.vertexA);
			newB.copyFrom(i.vertexB);
			newC.copyFrom(i.vertexC);
			
			//camera space
			newA.x -= activeCamera.x; newA.y -= activeCamera.y; newA.z -= activeCamera.z;
			newB.x -= activeCamera.x; newB.y -= activeCamera.y; newB.z -= activeCamera.z;
			newC.x -= activeCamera.x; newC.y -= activeCamera.y; newC.z -= activeCamera.z;
			
			//newA.subtract(new Vector3D(activeCamera.x, activeCamera.y, activeCamera.z));
		
			//canvas space
			newA.x /= (newA.z + 100) * 0.01;
			newA.y /= (newA.z + 100) * 0.01;
			
			newB.x /= (newB.z + 100) * 0.01;
			newB.y /= (newB.z + 100) * 0.01;
			
			newC.x /= (newC.z + 100) * 0.01;
			newC.y /= (newC.z + 100) * 0.01;
			
			
			newA.x *= FlxG.height / 80; newA.y *= FlxG.height / 80;
			newB.x *= FlxG.height / 80; newB.y *= FlxG.height / 80;
			newC.x *= FlxG.height / 80; newC.y *= FlxG.height / 80;
			
			newA.x +=FlxG.width / 2; newA.y += FlxG.height / 2;
			newB.x += FlxG.width / 2; newB.y += FlxG.height / 2;
			newC.x += FlxG.width / 2; newC.y += FlxG.height / 2;
			
			
			var vertices = new Array<FlxPoint>();
			vertices[0] = new FlxPoint(newA.x, newA.y);
			vertices[1] = new FlxPoint(newB.x, newB.y);
			vertices[2] = new FlxPoint(newC.x, newC.y);
			
			//trace(newA.x + "__" + newA.y);
			
			var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 1 };
			var drawStyle:DrawStyle = { smoothing: false };
			
			canvas.drawPolygon(vertices, i.color, lineStyle, drawStyle);
		}
		
		super.update(elapsed);
	}
}
