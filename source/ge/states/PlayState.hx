package ge.states;

import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import ge.game.Sonic;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ge.ui.HUD;
import flixel.FlxCamera;
import flixel.text.FlxText;


class PlayState extends FlxState
{
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var sonic:Sonic;
	var engineText:FlxText;
	var hud:HUD;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var timeAccumulator:Float = 0;
	var livesText:FlxText;

	override public function create()
	{
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera._defaultCameras  = [camGame];

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

		hud = new HUD();
		add(hud);

		hud.cameras = [camHUD];

		camGame.follow(sonic, LOCKON);
		camGame.setScrollBoundsRect(0, 0, walls.width, walls.height);
		camGame.zoom = 2.5;

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

		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.ONE) {
			DebugFunctions.addLives(1);
		}

		if (FlxG.keys.justPressed.TWO) {
			DebugFunctions.addRings(5);
		}

		if (FlxG.keys.justPressed.THREE) {
			DebugFunctions.addScore(100);
		}
		
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

		timeAccumulator += elapsed;
		if (timeAccumulator >= 1.0) {
			Globals.time++;
			timeAccumulator -= 1.0;
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
