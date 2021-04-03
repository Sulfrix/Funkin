package;

import openfl.display.Graphics;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class ScorePopup extends FlxText
{
	public var scoreChange:Float;
	public var xSpeed:Float;
	public var ySpeed:Float;
	public var lifeTime:Float;
	public var maxLifeTime:Float = 45;

	public static var gravity:Float = 0.2;

	public override function new(x:Float, y:Float, change:Float)
	{
		scoreChange = change;
		super(x, y, 0, "", 20);
		setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, OUTLINE, 0xFF000000);
		if (scoreChange > 0)
		{
			text = "+" + scoreChange;
			color = 0x70e5ff;
		}
		if (scoreChange < 0)
		{
			text = "-" + Math.abs(scoreChange);
			color = 0xF54242;
		}
		xSpeed = (Math.random() - 0.5) * 3;
		ySpeed = -((Math.random() * 1.5) + 3);
		lifeTime = maxLifeTime;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		lifeTime -= 1;
		// trace("lifetime: " + lifeTime);
		x += xSpeed;
		y += ySpeed;
		ySpeed += gravity;
		alpha = lifeTime / maxLifeTime;
		if (lifeTime <= 0)
		{
			// trace("Score text killed!");
			kill();
			destroy();
		}
	}
	
	//public override function draw() {
	//	super.draw();
	//	
	//}
}
