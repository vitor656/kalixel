package kalixel.behaviors;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

class TopDownBehavior extends Behavior
{
	public var speed:Float = 50;

	public var upKeys:Array<FlxKey> = [FlxKey.W, FlxKey.UP];
	public var downKeys:Array<FlxKey> = [FlxKey.S, FlxKey.DOWN];
	public var leftKeys:Array<FlxKey> = [FlxKey.A, FlxKey.LEFT];
	public var rightKeys:Array<FlxKey> = [FlxKey.D, FlxKey.RIGHT];

	public function new(owner:FlxSprite, ?state:FlxState = null)
	{
		super(owner, state);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyPressed(upKeys))
		{
			owner.velocity.y = -speed;
		}
		else if (FlxG.keys.anyPressed(downKeys))
		{
			owner.velocity.y = speed;
		}
		else
		{
			owner.velocity.y = 0;
		}

		if (FlxG.keys.anyPressed(leftKeys))
		{
			owner.velocity.x = -speed;
		}
		else if (FlxG.keys.anyPressed(rightKeys))
		{
			owner.velocity.x = speed;
		}
		else
		{
			owner.velocity.x = 0;
		}

		super.update(elapsed);
	}
}
