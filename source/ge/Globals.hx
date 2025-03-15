package ge;

// global shitz, mainly cuz why not
class Globals
{
    public static var spindashActive:Bool = true; // SET TO FALSE IF U DONT WANT THE SPINDASH AT ALL LOL
    public static var dropDashActive:Bool = true; // SET TO FALSE IF U DONT WANT THE DROP DASH AT ALL LOL
    
    public static var rings:Int = 0;
    public static var score:Int = 0;
    public static var time:Int = 0;
    public static var lives:Int = 3;
    public static var selectedCharacter:Int = 0; // 0=Sonic&Tails, 1=Sonic, 2=Tails, 3=Knuckles
    
    public static function resetGameState():Void {
        rings = 0;
        score = 0;
        time = 0;
    }
}
