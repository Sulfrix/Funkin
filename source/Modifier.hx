package;

typedef ModOptions =
{
	var prettyName:String;
	var name:String;
	var scoreMult:Float;
	var nonCompat:Array<String>;
	var enabled:Bool;
	var desc:String;
	var hidden:Bool;
}

class Modifier
{
	public var prettyName:String;
	public var name:String;
	public var scoreMult:Float;
	public var nonCompat:Array<String>;
	public var enabled:Bool;
	public var desc:String;
	public var hidden:Bool;

	public function new(options:ModOptions)
	{
		prettyName = options.prettyName;
		name = options.name;
		scoreMult = options.scoreMult;
		nonCompat = options.nonCompat;
		enabled = options.enabled;
		desc = options.desc;
		hidden = options.hidden;
	}

	public function getConflicts():Array<Modifier>
	{
		var conflicts:Array<Modifier> = [];
		for (incompat in nonCompat)
		{
			var badMod = Conductor.getModifierByName(incompat);
			if (badMod.enabled)
			{
				conflicts.push(badMod);
			}
		}
    return conflicts;
	}
}
