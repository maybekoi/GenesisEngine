package ge.states;

import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import ge.game.Sonic;
/*
import ge.game.Tails;
import ge.game.Knuckles;
*/

class PlayState extends StageState
{
    override function loadLevel(mapPath:String = null, levelPath:String = null, tilesetPath:String = null, layerName:String = "Map"):Void
    {
        trace("PlayState loading level: " + currentLevel);
        
        var levelFile = "level" + currentLevel + ".json";
        
        super.loadLevel(
            "assets/data/maps.ogmo", 
            "assets/data/levels/" + levelFile, 
            "Sonic1_MD_Map_GHZ_blocks", 
            "Map"
        );
        
        walls.setTileProperties(1, NONE);
        walls.setTileProperties(2, ANY);
        
        camGame.zoom = 2.5;
    }

    override function createPlayer():Void
    {
        trace("Creating player with character: " + Globals.selectedCharacter);
        
        switch (Globals.selectedCharacter)
        {
            case 0:
                player = new Sonic();
                // npc = new TailsNPC(player);
            case 1:
                player = new Sonic();
            case 2:
            case 3:
            default:
                player = new Sonic();
        }
    }
    
    override public function create():Void
    {
        trace("PlayState create - Selected character: " + Globals.selectedCharacter);
        super.create();
    }
}