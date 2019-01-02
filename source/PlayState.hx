package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxSlider;
import flixel.graphics.FlxGraphic;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.DrawStyle;
import flixel.util.FlxSpriteUtil.LineStyle;
import haxe.ds.Vector;
import openfl.display.BlendMode;
import openfl.geom.Vector3D;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	
	var ent:Entity;
	
	var activeCamera:Camera;
	
	var ambient:Int = 0x000;
	var ambientIntensity:Float = 0.2;
	
	var canvas:FlxSprite;
	
	var testi:FlxSprite;
	var walli:FlxSprite;
	
	override public function create():Void
	{
		//DEBUG GRID
		canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, 0x2a2435, true);
		
		var lineStyle:LineStyle = { color: FlxColor.BROWN, thickness: 1 };
		var drawStyle:DrawStyle = { smoothing: false };
		
		FlxSpriteUtil.drawCircle(canvas, 100, 100, 4, FlxColor.BROWN);
		for (i in 0...20)
		{
			if (i % 5 == 0) lineStyle = { color: FlxColor.CYAN, thickness: 1 };
			else lineStyle = { color: FlxColor.BROWN, thickness: 1 };
			FlxSpriteUtil.drawLine(canvas, i*10, 0, i*10, 200, lineStyle);
			FlxSpriteUtil.drawLine(canvas, 0, i*10, 200, i*10, lineStyle);
		}
		canvas.x = 20; canvas.y = 20;
		
		testi = new FlxSprite();
		testi.makeGraphic(40, 40, 0x00000000);
		FlxSpriteUtil.drawTriangle(testi, 10, 20, 20, 0x550055ff);
		FlxSpriteUtil.drawCircle(testi, 20, 20, 2, FlxColor.RED);
		
		ent = new Entity(0, 0, 10);
		add(ent);
		
		walli = new FlxSprite();
		walli.makeGraphic(2, 2, 0xffffff00);
		walli.x = ent.x + 120; 
		walli.y = ent.z + 120; 
		
		activeCamera = new Camera(0, 0, -10);
		
		
		
		add(canvas);
		add(walli);
		add(testi);
		
		add(new FlxSlider(this, "EZ", 10, 250, -500, 500, 100, 10, 3, 0xff555500));
		add(new FlxSlider(this, "fov", 10, 300, -120, 120, 100, 10, 3, 0xff555500));
		
		super.create();
		
	}

	override public function update(elapsed:Float):Void
	{
		
		if (FlxG.keys.anyPressed([W])) activeCamera.velocity.z -= 0.02;
		if (FlxG.keys.anyPressed([S])) activeCamera.velocity.z += 0.02;
		
		if (FlxG.keys.anyPressed([A])) activeCamera.velocity.x -= 0.02;
		if (FlxG.keys.anyPressed([D])) activeCamera.velocity.x += 0.02;
		
		if (FlxG.keys.anyPressed([Q])) activeCamera.yaw -= 1;
		if (FlxG.keys.anyPressed([E])) activeCamera.yaw += 1;
		
		testi.angle = activeCamera.yaw;
		testi.x = activeCamera.x+100;
		testi.y = activeCamera.z+100;
		
		activeCamera.velocity.scaleBy(0.9);
		
		
		activeCamera.moveAngle("y", activeCamera.yaw, activeCamera.velocity.z);
		activeCamera.moveAngle("y", activeCamera.yaw+90, activeCamera.velocity.x);
		
		
		super.update(elapsed);
	}
	
	var EZ:Int = 90;
	var fov:Int = 90;
	
	override public function draw():Void
	{
		
		var newC:Vector3D = new Vector3D();
		var newB:Vector3D = new Vector3D();
		var newA:Vector3D = new Vector3D();
		var newD:Vector3D = new Vector3D();
		
		
		
		thisGraphic = FlxGraphic.fromAssetKey("assets/images/test.png", false, null, false);
		
		
		
		colors = new DrawData();
			colors.push(0xff555555);
		
		
		for (i in ent.mesh.data)
		{
			
			newA.copyFrom(i.vertexA);
			newB.copyFrom(i.vertexB);
			newC.copyFrom(i.vertexC);
			newD.copyFrom(i.vertexD);
			
			//camera space
			
				//position
			newA.x -= activeCamera.x; newA.y -= activeCamera.y; newA.z -= activeCamera.z;
			newB.x -= activeCamera.x; newB.y -= activeCamera.y; newB.z -= activeCamera.z;
			newC.x -= activeCamera.x; newC.y -= activeCamera.y; newC.z -= activeCamera.z;
			newD.x -= activeCamera.x; newD.y -= activeCamera.y; newD.z -= activeCamera.z;
			
				//angle
			var vectorList:Array<Vector3D> = [newA, newB, newC, newD];
			for (k in vectorList)
			{/*
				// Rotate about the X-axis
				var tempA:Float =  Math.cos(activeCamera.angle) * k.y + Math.sin(rotation.x) * k.z;
				var tempB:Float = -Math.sin(rotation.x) * k.y + Math.cos(rotation.x) * k.z;
				k.y = tempA;
				k.z = tempB;*/
				
				// Rotate about the Y-axis
				var a:FlxPoint = new FlxPoint(k.x, k.z);
				a.rotate(new FlxPoint(activeCamera.x, activeCamera.z), -activeCamera.yaw);
				/*var tempA = Math.cos(FlxAngle.asRadians(-activeCamera.yaw)) * (k.x -activeCamera.x) + Math.sin(FlxAngle.asRadians(-activeCamera.yaw)) * (k.z -activeCamera.z);
				var tempB = Math.sin(FlxAngle.asRadians(-activeCamera.yaw)) * (k.x -activeCamera.x) + Math.cos(FlxAngle.asRadians(-activeCamera.yaw)) * (k.z -activeCamera.z);
				*/k.x = a.x;
				k.z = a.y;
				/*
				// Rotate about the Z-axis
				tempA =  Math.cos(rotation.z) * k.x + Math.sin(rotation.z) * k.y;
				tempB = -Math.sin(rotation.z) * k.x + Math.cos(rotation.z) * k.y;
				k.x = tempA;
				k.y = tempB;*/
			}
			
			// POINT IS BEHIND CAMERA --> DON'T RENDER (or maybe we should..)
			//if (newA.z <= 0)
			//	continue;
			
			
			//Project to screen space
			//using flat3d haxepunk algorithm
			
			var vectorList:Array<Vector3D> = [newA, newB, newC, newD];
			for (j in vectorList)
			{
				// Determines how small + close to the horizon the object should be rendered in the distance
				var depthFactor:Float = (100 + j.z) * (1 / 100);
				var depthInverse:Float = 1.0 - depthFactor;
				
				var fovX:Int = 90;
				var fovY:Int = 90;
				
				//j.x = ((j.x + (FlxG.width / 2)) * depthFactor) + ((FlxG.width / 2) * depthInverse);
				//j.y = ((j.y + (FlxG.height / 2)) * depthFactor) + ((FlxG.height / 2) * depthInverse);
				
				//j.x = j.z * (2 * Math.tan(fovX/2));
				//j.y = j.z * (2 * Math.tan(fovY / 2));
				
				
				
				//j.x = ((EZ/j.z) * j.x) + (FlxG.width / 2);
				//j.y = ((EZ/j.z) * j.y) + (FlxG.height / 2);
				
				j.x = (j.;
				j.y = ((EZ / j.z) * j.x) + (FlxG.width / 2);
			}
			
			/*newA.x /= (newA.z + 100) * 0.01;
			newA.y /= (newA.z + 100) * 0.01;
			
			newB.x /= (newB.z + 100) * 0.01;
			newB.y /= (newB.z + 100) * 0.01;
			
			newC.x /= (newC.z + 100) * 0.01;
			newC.y /= (newC.z + 100) * 0.01;
			
			newD.x /= (newD.z + 100) * 0.01;
			newD.y /= (newD.z + 100) * 0.01;
			
			
			newA.x *= FlxG.height / 80; newA.y *= FlxG.height / 80;
			newB.x *= FlxG.height / 80; newB.y *= FlxG.height / 80;
			newC.x *= FlxG.height / 80; newC.y *= FlxG.height / 80;
			newD.x *= FlxG.height / 80; newD.y *= FlxG.height / 80;
			
			newA.x +=FlxG.width / 2; newA.y += FlxG.height / 2;
			newB.x += FlxG.width / 2; newB.y += FlxG.height / 2;
			newC.x += FlxG.width / 2; newC.y += FlxG.height / 2;
			newD.x += FlxG.width / 2; newD.y += FlxG.height / 2;*/
			
			
			var vertices = new Array<FlxPoint>();
			vertices[0] = new FlxPoint(newA.x, newA.y);
			vertices[1] = new FlxPoint(newB.x, newB.y);
			vertices[2] = new FlxPoint(newC.x, newC.y);
			vertices[3] = new FlxPoint(newD.x, newD.y);
			
			//trace(newA.x + "__" + newA.y);
			
			
			
			
			
			
			
			
			
			thisvertices = new DrawData();
			thisvertices.push(newA.x); thisvertices.push(newA.y); thisvertices.push(newB.x); thisvertices.push(newB.y);
			thisvertices.push(newC.x); thisvertices.push(newC.y); thisvertices.push(newD.x); thisvertices.push(newD.y);
			
			var indexArray:Array<Int> = [3,0,1, 3,0,2];
			thisindices = new DrawData();
			for (j in indexArray)
			{
				thisindices.push(j);
			}
			
			thisuvtData = new DrawData(); 
			for (k in i.uvOffset)
			{
				thisuvtData.push(k);
			}
			
			camera.drawTriangles(thisGraphic, thisvertices, thisindices, thisuvtData, colors, new FlxPoint(20, 20), BlendMode.NORMAL);
		
			
			
			//canvas.drawPolygon(vertices, i.color, lineStyle, drawStyle);
		}
		
			
		
		super.draw();
		
	}
	
	var thisGraphic:FlxGraphic;
	var thisvertices:DrawData<Float>;
	var thisindices:DrawData<Int>;
	var thisuvtData:DrawData<Float>;
	var colors:DrawData<Int>;
	
	/**
	 * Use to offset the drawing position of the mesh.
	 */
	var thisdrawOffset:FlxPoint;
}
