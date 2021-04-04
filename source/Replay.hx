package;

class Replay {
  public var songName:String;
  public var difficulty:Int;
  public var frames:Array<ReplayFrame> = [];
  public var week:Int;

  public static var lastReplay:Replay;

  public function new(songN: String, diff: Int, week: Int) {
    songName = songN;
    difficulty = diff;
    this.week = week;
  }

  public function simulate() {
    var fakeState = ReplayPlayer.newFromReplay(this);
    fakeState.create();
    for (fakeFrame in frames) {
      fakeState.update(0.016);
    }
    return fakeState;
  }
}