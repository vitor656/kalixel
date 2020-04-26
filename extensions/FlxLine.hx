package kalixel.extensions;

import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class FlxLine extends FlxSprite
{
	public var originPoint:FlxPoint;
	public var destinationPoint:FlxPoint;
	public var thickness:Int = 1;

	public function new(?originPoint:FlxPoint, ?destinationPoint:FlxPoint, ?color:FlxColor = FlxColor.WHITE)
	{
		super();
		makeGraphic(1, thickness, color);

		if (originPoint != null)
			this.originPoint = originPoint;
		else
			this.originPoint = new FlxPoint();

		if (destinationPoint != null)
			this.destinationPoint = destinationPoint;
		else
			this.destinationPoint = new FlxPoint();
	}

	override function update(elapsed:Float)
	{
		origin.set(0, 0);

		if (originPoint != null)
		{
			x = originPoint.x;
			y = originPoint.y;
		}

		if (destinationPoint != null)
		{
			setGraphicSize(FlxMath.distanceToPoint(this, destinationPoint), thickness);
			angle = FlxAngle.angleBetweenPoint(this, destinationPoint, true);
		}

		super.update(elapsed);
	}
}
