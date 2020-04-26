package kalixel.extensions;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxColor;

class FlxDialogBox extends FlxTypedGroup<FlxSprite>
{
	var _newLineSet:Bool = false;
	var _timeToNextLineCounter:Float;
	var _currentLine:Int;
	var _onCompleteDialog:() -> Void;
	var _onCompleteDialogTriggered:Bool;
	var _detectedLimitHeight:Bool = false;
	var _referenceX:Float = 0;
	var _referenceY:Float = 0;

	public var box:FlxSprite;
	public var padding:Int;
	public var skipKeys:Array<FlxKey>;
	public var permitSkipLine:Bool = true;
	public var timeToNextLine:Float = 3;

	public var dialogLines(default, null):Array<String>;
	public var typeSound(default, set):FlxSoundAsset;
	public var typeSpeed(default, set):Float;
	public var textScale(default, set):FlxPoint;
	public var dialogCompleted(default, null):Bool;
	public var typeTextObject(default, null):FlxBitmapTypeText;

	public function new(?backgroundBox:FlxSprite = null, ?padding:Int = 8, ?typeSpeed:Float = 0.05, ?dialogLines:Array<String> = null,
			?skipKeys:Array<FlxKey> = null)
	{
		super();

		this.padding = padding;

		typeTextObject = new FlxBitmapTypeText();

		this.typeSpeed = typeSpeed;

		if (backgroundBox != null)
		{
			box = backgroundBox;
		}
		else
		{
			makeSolidDialogBox(FlxG.width - (Std.int(FlxG.width / 5)), Std.int(FlxG.height / 2) - Std.int(FlxG.height / 5), FlxColor.BLACK);
			centerOnScreenBottom();
		}

		add(box);
		add(typeTextObject);

		if (dialogLines != null)
			this.dialogLines = dialogLines;

		if (skipKeys != null)
			this.skipKeys = skipKeys;

		_timeToNextLineCounter = 0;
		_currentLine = 0;
		dialogCompleted = false;
	}

	override function update(elapsed:Float)
	{
		if (box != null && typeTextObject != null)
		{
			setupTypetext();
		}

		if (typeTextObject.isTyping)
		{
			if (permitSkipLine && skipKeys != null && skipKeys.length > 0)
			{
				if (FlxG.keys.anyJustPressed(skipKeys))
				{
					typeTextObject.skipToEnd();
				}
			}

			if (typeTextObject.height > (box.height - padding) && !_detectedLimitHeight)
			{
				continueTypingOnNextPage();
				_detectedLimitHeight = true;
			}
		}
		else
		{
			if (typeTextObject.typeStarted && typeTextObject.typeEnded)
			{
				if (permitSkipLine)
				{
					if (skipKeys != null && skipKeys.length > 0 && FlxG.keys.anyJustPressed(skipKeys))
					{
						nextTextLine();
					}
				}
				else
				{
					_timeToNextLineCounter += elapsed;
					if (_timeToNextLineCounter >= timeToNextLine)
					{
						nextTextLine();
						_timeToNextLineCounter = 0;
					}
				}
			}
		}

		super.update(elapsed);
	}

	public function start(?onCompleteDialog:() -> Void)
	{
		if (onCompleteDialog != null)
		{
			_onCompleteDialog = onCompleteDialog;
			_onCompleteDialogTriggered = false;
		}

		typeTextObject.start();
		dialogCompleted = false;
	}

	public function makeSolidDialogBox(width:Int, height:Int, color:FlxColor)
	{
		for (m in members)
		{
			remove(m);
		}

		box = new FlxSprite();
		box.makeGraphic(width, height, color);

		setupTypetext();

		add(box);
		add(typeTextObject);
	}

	public function centerOnScreenBottom()
	{
		if (box != null)
		{
			box.screenCenter();
			box.y = FlxG.height - box.height - padding;

			_referenceX = box.x;
			_referenceY = box.y;
		}
	}

	public function centerOnScreenTop()
	{
		if (box != null)
		{
			box.screenCenter();
			box.y = padding;

			_referenceX = box.x;
			_referenceY = box.y;
		}
	}

	public function setupDialogLines(textLines:Array<String>)
	{
		dialogLines = textLines;
	}

	public function setPosition(x:Float, y:Float)
	{
		if (box != null)
		{
			box.setPosition(x, y);

			_referenceX = box.x;
			_referenceY = box.y;
		}
	}

	function continueTypingOnNextPage()
	{
		var indexReference:Int = typeTextObject.text.length - 1;
		trace(typeTextObject.text);
		while (indexReference > 0)
		{
			if (typeTextObject.completeText.charAt(indexReference) == " ")
			{
				indexReference++;
				break;
			}
			indexReference--;
		}

		typeTextObject.completeText = typeTextObject.completeText.substring(indexReference, typeTextObject.completeText.length - 1);
		typeTextObject.start();
	}

	function nextTextLine()
	{
		if (_currentLine < dialogLines.length - 1)
		{
			_currentLine++;
			_newLineSet = false;

			setupTypetext();
			start();
		}
		else
		{
			dialogCompleted = true;
			if (_onCompleteDialog != null && !_onCompleteDialogTriggered)
			{
				_onCompleteDialog();
				_onCompleteDialogTriggered = true;
			}
			else
			{
				kill();
			}
		}
	}

	function setupTypetext()
	{
		if (box != null)
		{
			if (typeTextObject != null)
			{
				typeTextObject.x = box.x + padding;
				typeTextObject.y = box.y + padding;
				typeTextObject.fieldWidth = Std.int(box.width) - (padding * 2);
				typeTextObject.autoSize = false;
				typeTextObject.lineSpacing = 4;

				if (dialogLines != null)
				{
					if (typeTextObject.completeText != dialogLines[_currentLine] && !_newLineSet)
					{
						typeTextObject.completeText = dialogLines[_currentLine];
						_newLineSet = true;
					}
				}
			}
		}
	}

	function set_typeSpeed(typeSpeed:Float)
	{
		if (typeTextObject != null)
		{
			typeTextObject.typeIntervalTime = typeSpeed;
		}

		return this.typeSpeed;
	}

	function set_typeSound(sound:FlxSoundAsset)
	{
		if (typeTextObject != null)
		{
			typeTextObject.typeSound = sound;
		}

		return sound;
	}

	function set_textScale(scale:FlxPoint)
	{
		if (typeTextObject != null)
		{
			typeTextObject.scale.set(scale.x, scale.y);
			textScale = scale;
			setupTypetext();
		}

		return textScale;
	}
}
