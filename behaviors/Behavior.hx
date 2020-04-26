package kalixel.behaviors;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;

class Behavior extends FlxBasic
{
	public var owner(default, null):FlxSprite;
	public var state(default, null):FlxState;

	public function new(owner:FlxSprite, ?state:FlxState = null)
	{
		super();

		this.owner = owner;
		this.state = state;

		if (state != null)
			this.state.add(this);
	}
}
