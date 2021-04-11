package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
// import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var storyModeButton:Button;
	var testButton:Button;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		trace("Screen Height: " + FlxG.height);
		trace("BG Height: " + bg.height);
		trace("Divided: " + (FlxG.height / bg.height));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.scale.set((FlxG.height / bg.height), (FlxG.height / bg.height) * 1.1);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.scale.set(0.7, 0.7);
		logoBl.updateHitbox();
		logoBl.screenCenter();
		logoBl.y -= FlxG.height / 5;
		add(logoBl);

		storyModeButton = new Button(Mobile.edgePadding, FlxG.height - 400, FlxG.width - (Mobile.edgePadding * 2), 100, "Story Mode", 0xFF5100ff, UI);
		add(storyModeButton);

		testButton = new Button(Mobile.edgePadding, Mobile.edgePadding, 100, 100, "Test", 0xFF5100ff, UI);
		add(testButton);

		var versionShit:FlxText = new FlxText(25, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (storyModeButton.click) {
			storyModeButton.confirmed = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.switchState(new StoryMenuState());
		}
		if (testButton.click) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
	}
}
