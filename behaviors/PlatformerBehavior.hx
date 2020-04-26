package kalixel.behaviors;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

class PlatformerBehavior extends Behavior
{
	public var jumpKeys:Array<FlxKey> = [FlxKey.W, FlxKey.UP, FlxKey.SPACE];
	public var downKeys:Array<FlxKey> = [FlxKey.S, FlxKey.DOWN];
	public var leftKeys:Array<FlxKey> = [FlxKey.A, FlxKey.LEFT];
	public var rightKeys:Array<FlxKey> = [FlxKey.D, FlxKey.RIGHT];

	public var gravity(default, set):Float = 600;
	public var moveSpeed:Float = 100;
	public var jumpForce:Float = 170;

	public function new(owner:FlxSprite, ?state:FlxState = null)
	{
		super(owner, state);

		owner.acceleration.set(0, gravity);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyPressed(leftKeys))
		{
			owner.velocity.x = -moveSpeed;
		}
		else if (FlxG.keys.anyPressed(rightKeys))
		{
			owner.velocity.x = moveSpeed;
		}
		else
		{
			owner.velocity.x = 0;
		}

		if (owner.isTouching(FlxObject.FLOOR))
		{
			if (FlxG.keys.anyJustPressed(jumpKeys))
			{
				owner.velocity.y = -jumpForce;
			}
		}
		else
		{
			if (FlxG.keys.anyJustReleased(jumpKeys) && owner.velocity.y < 0 && owner.velocity.y < -(jumpForce / 2))
			{
				owner.velocity.y = -jumpForce / 2;
			}
		}

		super.update(elapsed);
	}

	function set_gravity(grav:Float)
	{
		gravity = grav;
		owner.acceleration.set(0, gravity);

		return gravity;
	}
}
