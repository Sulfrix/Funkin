package;

import flixel.FlxG;
import flixel.input.touch.FlxTouch;
import flixel.input.touch.FlxTouchManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

enum ButtonBehavior
{
	UI;
	Control;
	LooseControl;
}

class Button extends FlxTypedSpriteGroup<FlxSprite>
{
	public var text:String;
	public var behavior:ButtonBehavior;

	public var confirmed = false;
	public var hide = false;

	public var justPressed:Bool = false;
	public var isPressed:Bool = false;
	public var justReleased:Bool = false;
	/**
		* Use with buttons with UI behavior.
	**/
	public var click:Bool = false;

	private var touchedPoint:FlxTouch;
	private var textObj:FlxText;
	private var bg:FlxSprite;

	public override function new(x:Float = 0, y:Float = 0, width:Float = 100, height:Float = 100, text:String = "", color:FlxColor = 0xFF5100ff,
			behavior:ButtonBehavior = Control)
	{
		super(x, y, 2);
		this.width = width;
		this.height = height;
		this.text = text;

		this.behavior = behavior;

		bg = new FlxSprite(0, 0).makeGraphic(Math.round(width), Math.round(height), color);
		bg.alpha = 0.5;
		add(bg);

		textObj = new FlxText(width / 2, height / 2, 0, text, 30);
		textObj.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, OUTLINE, 0xFF000000);
		textObj.x -= textObj.width / 2;
		textObj.y -= textObj.height / 2;
		add(textObj);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!confirmed) {
			switch (behavior)
			{
				case UI:
					if (touchedPoint == null)
					{
						click = false;
						pressUp();
						for (touch in FlxG.touches.justStarted())
						{
							if (touch.overlaps(this, this.camera))
							{
								pressDown();
								touchedPoint = touch;
								break;
							}
						}
					} else {
						if (touchedPoint.overlaps(this.bg)) {
							pressDown();
						} else {
							pressUp();
						}
	
						if (touchedPoint.justReleased) {
							if (touchedPoint.overlaps(this.bg)) {
								click = true;
							}
							touchedPoint = null;
							//pressUp();
						}
					}
				case Control | LooseControl:
			}
		} else {
			click = false;
			pressDown();
		}
	}

	private function pressDown() {
		if (!hide) {
			bg.alpha = 1;
			textObj.alpha = 1;
		}
		else {
			textObj.alpha = 0;
			bg.alpha = 0;
		}
		if (!confirmed) {
			textObj.color = 0xFFffdd00;
		}
	}

	private function pressUp() {
		if (!hide) {
			bg.alpha = 0.5;
			textObj.alpha = 1;
		}
		else {
			textObj.alpha = 0;
			bg.alpha = 0;
		}
		textObj.color = 0xFFFFFFFF;
	}
}
