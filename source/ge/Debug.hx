package ge;

class Debug {
 // pee
}

class DebugFunctions
{
    public static function addLives(lives:Int)
    {
        Globals.lives += lives;
    }

    public static function addRings(rings:Int)
    {
        Globals.rings += rings;
    }

    public static function addScore(score:Int)
    {
        Globals.score += score;
    }
}
