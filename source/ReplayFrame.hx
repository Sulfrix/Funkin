package;

class ReplayFrame {
  public var controlArray:Array<Bool>;
  public var songPosition:Float;
  
  public function new(controlArr:Array<Bool>, songPos:Float) {
    controlArray = controlArr;
    songPosition = songPos;
  }
}