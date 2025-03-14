package ge.states;

import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import ge.game.Sonic;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var sonic:Sonic;
	var engineText:FlxText;
	override public function create()
	{
		trace("PlayState go brr!");
		map = new FlxOgmo3Loader("assets/data/maps.ogmo", "assets/data/levels/level1.json");
		walls = map.loadTilemap(Util.getImage("Sonic1_MD_Map_GHZ_blocks"), "Map");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		sonic = new Sonic();
		map.loadEntities(placeEntities, "Entities");
		add(sonic);

		FlxG.camera.follow(sonic, LOCKON);
		FlxG.camera.setScrollBoundsRect(0, 0, walls.width, walls.height);
		FlxG.camera.zoom = 2.5;

		engineText = new FlxText(0, 0, 500);
		engineText.text = "Welcome to Genesis Engine!";
		engineText.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, CENTER);
		engineText.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);
		add(engineText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var prevY = sonic.y;
		
		if (FlxG.collide(sonic, walls))
		{
			if (sonic.ySpeed >= 0)
			{
				sonic.isOnGround = true;
				sonic.ySpeed = 0;
				sonic.groundAngle = 0;
			}
			else
			{
				sonic.ySpeed = 0;
			}
		}
		else if (sonic.isOnGround && !FlxG.overlap(sonic, walls))
		{
			sonic.isOnGround = false;
		}
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "Player")
		{
			sonic.setPosition(entity.x, entity.y);
		}
	}
}
