package kalixel.extensions;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;

class FlxRaycast extends FlxBasic
{
	public static inline var UP:Int = 0;
	public static inline var DOWN:Int = 1;
	public static inline var LEFT:Int = 2;
	public static inline var RIGHT:Int = 3;

	public function new()
	{
		super();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public static function hitPoint(x:Float, y:Float, objectsToFind:Array<FlxObject>)
	{
		if (objectsToFind != null && objectsToFind.length > 0)
		{
			for (o in objectsToFind)
			{
				if (x >= o.x && x <= (o.x + o.width) && y >= o.y && y <= (o.y + o.height))
				{
					return o;
				}
			}
		}

		return null;
	}

	public static function hitLine(origin:FlxPoint, length:Float, direction:Int, objectsToFind:Array<FlxObject>)
	{
		var obj:FlxObject = null;
		var countCoord:Int = 0;
		while (countCoord < length)
		{
			switch (direction)
			{
				case UP:
					obj = hitPoint(origin.x, origin.y - countCoord, objectsToFind);
				case DOWN:
					obj = hitPoint(origin.x, origin.y + countCoord, objectsToFind);
				case LEFT:
					obj = hitPoint(origin.x - countCoord, origin.y, objectsToFind);
				case RIGHT:
					obj = hitPoint(origin.x + countCoord, origin.y, objectsToFind);
			}
			countCoord++;
		}

		return obj;
	}
}
