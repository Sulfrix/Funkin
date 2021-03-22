package;

import Song.SwagSong;

/**
 * ...
 * @author
 */

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Int;
}


class Conductor
{
	public static var bpm:Int = 100;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var songPosition:Float;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;
	public static var modifiers:Array<Modifier> = [
		new Modifier({
			prettyName: "Fade Out",
			name: "fadeout",
			scoreMult: 1.3,
			enabled: false,
			desc: "Notes fade out after they appear",
			nonCompat: ["fadein", "invisible"],
		}),
		new Modifier({
			prettyName: "Fade In",
			name: "fadein",
			scoreMult: 1.1,
			enabled: false,
			desc: "Notes are invisible until right before they need to be hit",
			nonCompat: ["fadeout", "invisible"],
		}),
		new Modifier({
			prettyName: "Invisible",
			name: "invisible",
			scoreMult: 3,
			enabled: false,
			desc: "Notes are invisible. Why?",
			nonCompat: ["fadeout", "fadein"],
		}),
		new Modifier({
			prettyName: "Full Modifiers",
			name: "enemy",
			scoreMult: 1,
			enabled: false,
			desc: "Certain modifiers will also effect the other player's notes",
			nonCompat: []
		}),
		new Modifier({
			prettyName: "No Fail",
			name: "nofail",
			scoreMult: 0.4,
			enabled: false,
			desc: "Health is locked to 50%",
			nonCompat: []
		}),
		new Modifier({
			prettyName: "No Miss Stun",
			name: "nooverstrum",
			scoreMult: 0.2,
			enabled: false,
			desc: "Disables miss stun",
			nonCompat: []
		})
	];

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new()
	{
	}

	public static function getModifierByName(name:String):Modifier {
		var out:Modifier;
		for (mod in modifiers) {
			if (mod.name.toLowerCase() == name.toLowerCase()) {
				return mod;
			}
		}
		return null;
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Int = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if(song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	public static function changeBPM(newBpm:Int)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}
