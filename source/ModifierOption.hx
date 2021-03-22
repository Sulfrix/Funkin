package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class ModifierOption extends FlxText {
  public var mod:Modifier;
  public var selected:Bool;

  public override function new(x:Float, y:Float, modifier:Modifier) {
    mod = modifier;
    super(x, y, 0, mod.prettyName, 20);
    super.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT);
  }

  public override function update(elapsed:Float) {
    super.update(elapsed);

    
    if (mod.enabled) {
      text = "[X] " + mod.prettyName;
    } else {
      text = "[ ] " + mod.prettyName;
    }

    if (selected) {
      color = FlxColor.YELLOW;
      var conflicts = mod.getConflicts();
      if (conflicts.length > 0) {
        text = text + " | Incompatible with: " + conflicts.map(item -> item.prettyName).join(", ");
      }
    } else {
      color = FlxColor.WHITE;
    }
  }

  public function toggle() {
    if (mod.getConflicts().length == 0) {
      mod.enabled = !mod.enabled;
    } else {
      FlxG.sound.play(Paths.sound('cancelMenu'));
    }
  }
}