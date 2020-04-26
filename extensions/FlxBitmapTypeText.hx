package kalixel.extensions;

import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.text.FlxBitmapText;

class FlxBitmapTypeText extends FlxBitmapText
{
	var _timeCounter:Float;
	var _typingText:String;
	var _currentTextIndex:Int;
	var _onComplete:() -> Void;
	var _onCompleteTriggered:Bool;

	public var typeIntervalTime:Float;
	public var completeText:String;

	public var isTyping(default, null):Bool;
	public var typeSound(default, set):FlxSoundAsset;
	public var typeEnded(default, null):Bool;
	public var typeStarted(default, null):Bool;

	public function new(?font:Null<FlxBitmapFont>, ?typeIntervalTime:Float = 0.1, ?text:String = "", ?typeSound:FlxSoundAsset = null)
	{
		super(font);

		this.typeIntervalTime = typeIntervalTime;
		this.completeText = text;
		this.typeSound = typeSound;

		if (this.typeSound != null)
			FlxG.sound.load(this.typeSound);

		resetParameters();
	}

	override function update(elapsed:Float)
	{
		if (typeStarted)
		{
			_timeCounter += elapsed;
			if (_timeCounter >= typeIntervalTime)
			{
				typeNextCharacter();
				_timeCounter = 0;
			}
		}

		super.update(elapsed);
	}

	function typeNextCharacter()
	{
		if (_currentTextIndex < completeText.length)
		{
			if (typeSound != null)
				FlxG.sound.play(typeSound);

			_currentTextIndex++;
			this.text = completeText.substr(0, _currentTextIndex);

			isTyping = true;
		}
		else
		{
			typeEnded = true;
			isTyping = false;

			if (_onComplete != null && !_onCompleteTriggered)
			{
				_onComplete();
				_onCompleteTriggered = true;
			}
		}
	}

	function resetParameters()
	{
		_timeCounter = 0;
		_currentTextIndex = 0;
		typeEnded = false;
		typeStarted = false;

		isTyping = false;

		this.text = "";
	}

	public function start(?onComplete:() -> Void)
	{
		resetParameters();
		if (!typeStarted)
		{
			if (text != "")
			{
				completeText = text;
				text = "";
			}

			typeStarted = true;

			_onComplete = onComplete;
			_onCompleteTriggered = false;
		}
	}

	public function skipToEnd()
	{
		_currentTextIndex = completeText.length;
		this.text = completeText.substr(0, _currentTextIndex);
		typeNextCharacter();
	}

	function set_typeSound(sound:FlxSoundAsset)
	{
		typeSound = sound;
		FlxG.sound.load(typeSound);

		return typeSound;
	}
}
