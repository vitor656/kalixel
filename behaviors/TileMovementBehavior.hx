package kalixel.behaviors;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

enum MoveDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class TileMovementBehavior extends Behavior
{
	public var upKeys:Array<FlxKey> = [FlxKey.W, FlxKey.UP];
	public var downKeys:Array<FlxKey> = [FlxKey.S, FlxKey.DOWN];
	public var leftKeys:Array<FlxKey> = [FlxKey.A, FlxKey.LEFT];
	public var rightKeys:Array<FlxKey> = [FlxKey.D, FlxKey.RIGHT];

	public var tileSize:Int = 8;
	public var movementSpeed:Int = 1;
	public var moveToNextTile:Bool;

	public var previousDirectionCommand:MoveDirection;
	public var previousPosition:FlxPoint;

	var _moveDirection:MoveDirection;
	var _previousPositionRequested:Bool = false;
	var _movementDone:Bool = false;

	public function new(owner:FlxSprite, ?state:FlxState = null)
	{
		super(owner, state);
		previousPosition = new FlxPoint(owner.x, owner.y);
	}

	override function update(elapsed:Float)
	{
		if (moveToNextTile)
		{
			switch (_moveDirection)
			{
				case UP:
					owner.y -= movementSpeed;
				case DOWN:
					owner.y += movementSpeed;
				case LEFT:
					owner.x -= movementSpeed;
				case RIGHT:
					owner.x += movementSpeed;
			}
		}

		if ((owner.x % tileSize == 0) && (owner.y % tileSize == 0))
		{
			moveToNextTile = false;
			_movementDone = true;
		}

		if (!_previousPositionRequested)
		{
			if (FlxG.keys.anyPressed(downKeys))
			{
				moveTo(MoveDirection.DOWN);
			}
			else if (FlxG.keys.anyPressed(upKeys))
			{
				moveTo(MoveDirection.UP);
			}
			else if (FlxG.keys.anyPressed(leftKeys))
			{
				moveTo(MoveDirection.LEFT);
			}
			else if (FlxG.keys.anyPressed(rightKeys))
			{
				moveTo(MoveDirection.RIGHT);
			}
		}

		if (_previousPositionRequested && _movementDone)
		{
			_previousPositionRequested = false;
		}

		super.update(elapsed);
	}

	public function moveTo(direction:MoveDirection):Void
	{
		if (!moveToNextTile)
		{
			previousPosition.set(owner.x, owner.y);
			previousDirectionCommand = direction;

			_moveDirection = direction;
			moveToNextTile = true;

			_movementDone = false;
		}
	}

	public function goToPreviousPosition()
	{
		switch (previousDirectionCommand)
		{
			case UP:
				moveTo(MoveDirection.DOWN);
			case DOWN:
				moveTo(MoveDirection.UP);
			case LEFT:
				moveTo(MoveDirection.RIGHT);
			case RIGHT:
				moveTo(MoveDirection.LEFT);
		}

		_previousPositionRequested = true;
	}
}
