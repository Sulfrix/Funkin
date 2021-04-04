package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import openfl.utils.Object;

class ReplayControlInterface extends Controls
{
	override public function new()
	{
		super("Replay Controller", Replay);
	}

	override function get_UP()
		return ReplayPlayer.controller.UP;

	override function get_LEFT()
		return ReplayPlayer.controller.LEFT;

	override function get_RIGHT()
		return ReplayPlayer.controller.RIGHT;

	override function get_DOWN()
		return ReplayPlayer.controller.DOWN;

	override function get_UP_P()
		return ReplayPlayer.controller.UP_P;

	override function get_LEFT_P()
		return ReplayPlayer.controller.LEFT_P;

	override function get_RIGHT_P()
		return ReplayPlayer.controller.RIGHT_P;

	override function get_DOWN_P()
		return ReplayPlayer.controller.DOWN_P;

	override function get_UP_R()
		return ReplayPlayer.controller.UP_R;

	override function get_LEFT_R()
		return ReplayPlayer.controller.LEFT_R;

	override function get_RIGHT_R()
		return ReplayPlayer.controller.RIGHT_R;

	override function get_DOWN_R()
		return ReplayPlayer.controller.DOWN_R;
}

typedef ReplayController =
{
	var UP:Bool;
	var RIGHT:Bool;
	var DOWN:Bool;
	var LEFT:Bool;
	var UP_P:Bool;
	var RIGHT_P:Bool;
	var DOWN_P:Bool;
	var LEFT_P:Bool;
	var UP_R:Bool;
	var RIGHT_R:Bool;
	var DOWN_R:Bool;
	var LEFT_R:Bool;
}

class ReplayPlayer extends PlayState
{
	public static var controller:ReplayController = {
		UP: false, 
    RIGHT: false,
		DOWN: false,
		LEFT: false,
		UP_P: false,
		RIGHT_P: false,
		DOWN_P: false,
		LEFT_P: false,
		UP_R: false,
		RIGHT_R: false,
		DOWN_R: false,
		LEFT_R: false,
	};
	public static var contInterface:ReplayControlInterface = new ReplayControlInterface();

	public var frameCounter:Int = 0;

  public var replayText:FlxText;

	override public function new(replay:Replay)
	{
		currReplay = replay;
		super(null, null);
	}

	override public function create()
	{
		recording = false;
		super.create();
    replayText = new FlxText(5, 5, 0, "REPLAY", 60);
    replayText.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE);
    replayText.alpha = 0.5;
    replayText.cameras = [camHUD];
    add(replayText);
	}

	public static function playback(replay:Replay)
	{
		var poop:String = Highscore.formatSong(replay.songName.toLowerCase(), replay.difficulty);
		PlayState.SONG = Song.loadFromJson(poop, replay.songName.toLowerCase());
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = replay.difficulty;

		PlayState.storyWeek = replay.week;
		LoadingState.loadAndSwitchState(new ReplayPlayer(replay));
	}

  public static function newFromReplay(replay:Replay):ReplayPlayer {
    var poop:String = Highscore.formatSong(replay.songName.toLowerCase(), replay.difficulty);
		PlayState.SONG = Song.loadFromJson(poop, replay.songName.toLowerCase());
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = replay.difficulty;

		PlayState.storyWeek = replay.week;
		return new ReplayPlayer(replay);
  }

	override public function update(elapsed:Float)
	{
		var replay:Replay = currReplay;
    replayText.text = "REPLAY | " + Conductor.songPosition/1000 + "/" + (replay.frames.length*16)/1000;
		if (replay.frames[frameCounter] != null)
		{
			var daFrame:ReplayFrame = replay.frames[frameCounter];
			controller.LEFT = daFrame.controlArray[0];
			controller.DOWN = daFrame.controlArray[1];
			controller.UP = daFrame.controlArray[2];
			controller.RIGHT = daFrame.controlArray[3];

			var prevFrame:ReplayFrame; // DO NOT USE FOR ITS SONG POS, WILL LIKELY BE INCORRECT
			if (replay.frames[frameCounter - 1] != null)
			{
				prevFrame = replay.frames[frameCounter - 1];
			}
			else
			{
				prevFrame = new ReplayFrame([false, false, false, false], 0);
			}

			if (controller.LEFT && !prevFrame.controlArray[0])
			{
				controller.LEFT_P = true;
			}
			else
			{
				controller.LEFT_P = false;
			}
			if (controller.DOWN && !prevFrame.controlArray[1])
			{
				controller.DOWN_P = true;
			}
			else
			{
				controller.DOWN_P = false;
			}
			if (controller.UP && !prevFrame.controlArray[2])
			{
				controller.UP_P = true;
			}
			else
			{
				controller.UP_P = false;
			}
			if (controller.RIGHT && !prevFrame.controlArray[3])
			{
				controller.RIGHT_P = true;
			}
			else
			{
				controller.RIGHT_P = false;
			}

			if (!controller.LEFT && prevFrame.controlArray[0])
			{
				controller.LEFT_R = true;
			}
			else
			{
				controller.LEFT_R = false;
			}
			if (!controller.DOWN && prevFrame.controlArray[1])
			{
				controller.DOWN_R = true;
			}
			else
			{
				controller.DOWN_R = false;
			}
			if (!controller.UP && prevFrame.controlArray[2])
			{
				controller.UP_R = true;
			}
			else
			{
				controller.UP_R = false;
			}
			if (!controller.RIGHT && prevFrame.controlArray[3])
			{
				controller.RIGHT_R = true;
			}
			else
			{
				controller.RIGHT_R = false;
			}
			Conductor.songPosition = daFrame.songPosition;
		}
		super.update(elapsed);
		frameCounter++;
    if (frameCounter > replay.frames.length) {
      endSong();
    }
	}
}
