package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BlendMode;
import openfl.geom.Vector3D;

class Entity extends FlxBasic
{

	public var x:Float = 0;
	public var y:Float = 0;
	public var z:Float = 0;

	public var mesh:Mesh = new Mesh();

	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0)
	{
		place(x, y, z);


		//front
		mesh.add(new Tri([-1,  1, 0], [ 1,  1, 0], [-1, -1, 0], [ 1, -1, 0], [0,0, 0.5,0, 0,0.5, 0.5,0.5], FlxG.random.color(0x555555,0xffffff,255)));
		mesh.add(new Tri([1,  1, 0], [ 3,  1, 0], [1, -1, 0], [ 3, -1, 0], [0,0,0.5,0,0,0.5,0.5,0.5], FlxG.random.color(0x555555,0xffffff,255)));
		mesh.add(new Tri([-1, 3, 0], [ 1,  3, 0], [-1, 1, 0], [ 1, 1, 0], [0,0,0.5,0,0,0.5,0.5,0.5], FlxG.random.color(0x555555,0xffffff,255)));
		mesh.add(new Tri([1,  3, 0], [ 3,  3, 0], [1, 1, 0], [ 3, 1, 0], [0,0,0.5,0,0,0.5,0.5,0.5], FlxG.random.color(0x555555,0xffffff,255)));
		
		//back
		//mesh.add(new Tri([-1,  1,  1], [-1, -1,  1], [ 1, -1,  1], FlxG.random.color(0x555555,0xffffff,255)));
		
		//top
		//mesh.add(new Tri([-1, -1, -1], [-1, -1,  1], [ 1, -1, -1], FlxG.random.color(0x555555,0xffffff,255)));
		//bottom
		//mesh.add(new Tri([-1,  1, -1], [-1,  1,  1], [ 1,  1, -1], FlxG.random.color(0x555555,0xffffff,255)));
		
		//left
		//mesh.add(new Tri([-1,  1, -1], [-1, -1, -1], [-1, -1,  1], FlxG.random.color(0x555555,0xffffff,255)));
		//right
		//mesh.add(new Tri([ 1,  1, -1], [ 1, -1, -1], [ 1, -1,  1], FlxG.random.color(0x555555,0xffffff,255)));
		
		mesh.scale(10);

		super();
	}
	
	override public function update(elapsed:Float):Void
	{
		//mesh.rotate(0, 0.001, 0);
		
		//trace(mesh.rotation);
		
		super.update(elapsed);
	}

	public function move(?x:Float, ?y:Float, ?z:Float)
	{
		if (x != null) this.x += x;
		if (y != null) this.y += y;
		if (z != null) this.z += z;
	}

	public function moveAngle(axis:String, angle:Float, amount:Float)
	{
		var moveVector:FlxPoint = FlxAngle.getCartesianCoords(amount, angle);
		move(moveVector.y, 0, -moveVector.x);
	}
	
	
	public function place(?x:Float, ?y:Float, ?z:Float)
	{
		if (x != null) this.x = x;
		if (y != null) this.y = y;
		if (z != null) this.z = z;
	}

}

class Mesh
{
	public var data:Array<Tri> = [];
		
	public var rotation:Vector3D = new Vector3D();

	public function add(triangle:Tri)
	{
		data.push(triangle);
	}

	public function scale(factor:Float)
	{
		for (i in data)
		{
			i.vertexA.scaleBy(factor);
			i.vertexB.scaleBy(factor);
			i.vertexC.scaleBy(factor);
			i.vertexD.scaleBy(factor);
		}
	}
			
	public function rotate(angleX:Float, angleY:Float, angleZ:Float)
	{
		rotation.setTo(angleX, angleY, angleZ);
		
		for (i in data)
		{
			var vectorList:Array<Vector3D> = [i.vertexA, i.vertexB, i.vertexC, i.vertexD, i.normal];
			
			for (j in vectorList)
			{
				// Rotate about the X-axis
				var tempA:Float =  Math.cos(rotation.x) * j.y + Math.sin(rotation.x) * j.z;
				var tempB:Float = -Math.sin(rotation.x) * j.y + Math.cos(rotation.x) * j.z;
				j.y = tempA;
				j.z = tempB;
				
				// Rotate about the Y-axis
				tempA =  Math.cos(rotation.y) * j.x + Math.sin(rotation.y) * j.z;
				tempB = -Math.sin(rotation.y) * j.x + Math.cos(rotation.y) * j.z;
				j.x = tempA;
				j.z = tempB;
				
				// Rotate about the Z-axis
				tempA =  Math.cos(rotation.z) * j.x + Math.sin(rotation.z) * j.y;
				tempB = -Math.sin(rotation.z) * j.x + Math.cos(rotation.z) * j.y;
				j.x = tempA;
				j.y = tempB;
			}
		}
	}

	public function new()
	{
	}
}

class Tri
{
	public var vertexA:Vector3D;
	public var vertexB:Vector3D;
	public var vertexC:Vector3D;
	public var vertexD:Vector3D;
	
	public var uvOffset:Array<Float>;

	public var color:Int = 0x50587f;

	public var normal:Vector3D;

	public function new(a:Array<Float>, b:Array<Float>, c:Array<Float>, d:Array<Float>, ?uvoff:Array<Float>, ?color:Int)
	{
		if (a.length != 3 && b.length != 3 && c.length != 3 && d.length != 3)
			throw("Error: Vertex coordinates need to have exactly [x, y, z]");

		vertexA = new Vector3D(a[0], a[1], a[2]);
		vertexB = new Vector3D(b[0], b[1], b[2]);
		vertexC = new Vector3D(c[0], c[1], c[2]);
		vertexD = new Vector3D(d[0], d[1], d[2]);
		
		uvOffset = uvoff;
		
		normal = new Vector3D(0, 0, 0); //TODO

		if (color != null) this.color = color;
	}
}