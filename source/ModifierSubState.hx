package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;

class ModifierSubState extends MusicBeatSubstate
{
	var modListings:FlxTypedGroup<ModifierOption>;
	var descText:FlxText;
	var multText:FlxText;
	var cursor:Int = 0;

	public function new(x:Float, y:Float)
	{
		super();

		modListings = new FlxTypedGroup<ModifierOption>(100);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		bg.scrollFactor.set();
		add(bg);
		var modY:Float = y;

		var title:FlxText = new FlxText(x, modY, 0, "Modifiers", 40);
		title.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE);
		add(title);
		modY = modY + 42;

		descText = new FlxText(x, modY, 0, "", 30);
		descText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE);
		add(descText);
		modY = modY + 32;

		multText = new FlxText(x, modY, 0, "", 20);
		multText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE);
		multText.autoSize = true;
		add(multText);
		modY = modY + 22;

		var controlHint = new FlxText(x, FlxG.height - 42, 0, "Press L to view last replay.", 20);
		controlHint.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE);
		controlHint.autoSize = true;
    add(controlHint);
    //if (Replay.lastReplay != null) {
    //  var fakeState = Replay.lastReplay.simulate();
    //  controlHint.text = "Last replay score: " + fakeState.songScore + " [L to watch]";
    //}

		for (daMod in Conductor.modifiers)
		{
			if (!daMod.hidden)
			{
				var item:ModifierOption = new ModifierOption(x, modY, daMod);
				modListings.add(item);
				modY = modY + 22;
			}
		}
		add(modListings);

		switchSelected(0);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		var selectedOption:ModifierOption = getSelected();

		if (controls.ACCEPT)
		{
			selectedOption.toggle();
			updateText();
		}
		if (controls.UP_P)
		{
			switchSelected(-1);
		}
		if (controls.DOWN_P)
		{
			switchSelected(1);
		}

		if (controls.CHEAT)
		{
			if (Replay.lastReplay != null)
				ReplayPlayer.playback(Replay.lastReplay);
		}

		if (controls.BACK)
		{
			FlxG.state.closeSubState();
		}
	}

	public function switchSelected(amt:Int)
	{
		cursor += amt;
		FlxG.sound.play(Paths.sound('scrollMenu'));
		if (cursor < 0)
		{
			cursor = modListings.length - 1;
		}
		if (cursor >= modListings.length)
		{
			cursor = 0;
		}
		updateText();
	}

	function updateText()
	{
		var sel = getSelected();
		descText.text = sel.mod.desc;
		var totalMult:Float = 1;
		for (mod in Conductor.modifiers)
		{
			if (mod.enabled)
			{
				totalMult = totalMult * mod.scoreMult;
			}
		}
		multText.text = "Total Multiplier: x" + totalMult + " | " + sel.mod.prettyName + ": x" + sel.mod.scoreMult;
	}

	function getSelected():ModifierOption
	{
		var listIndex = 0;
		var output:ModifierOption = null;
		for (modOpt in modListings)
		{
			if (listIndex == cursor)
			{
				modOpt.selected = true;
				output = modOpt;
			}
			else
			{
				modOpt.selected = false;
			}
			listIndex++;
		}
		return output;
	}
}
