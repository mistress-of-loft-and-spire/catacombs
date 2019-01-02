package;
import flixel.math.FlxPoint;
import openfl.geom.Vector3D;

class Camera extends Entity
{
	
	public var pitch:Float = 0;
	public var yaw:Float = 0;
	public var roll:Float = 0;
	
	public var velocity:Vector3D = new Vector3D();

	public function new(?x:Float=0, ?y:Float=0, ?z:Float=0) 
	{
		super(x, y, z);
		
	}
	
}